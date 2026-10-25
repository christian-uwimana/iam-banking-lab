<#
.SYNOPSIS
  Sends HR records from a CSV export to Microsoft Entra API-driven inbound
  provisioning, which creates, updates or disables the matching Active
  Directory accounts.

.DESCRIPTION
  Each CSV row becomes one SCIM operation in a single bulk request (keep
  runs to 50 rows or fewer). Records are matched to existing accounts by
  employee ID, so re-sending an unchanged row is harmless.

  The script signs in as an app registration that holds only the
  SynchronizationData-User.Upload and AuditLog.Read.All application
  permissions. The client secret is typed at run time and never stored.

.EXAMPLE
  .\hr-feed.ps1 -CsvPath .\hr_feed_initial.csv
  (prompts for the client secret)
#>
param(
  [string]$CsvPath  = ".\hr_feed.csv",
  [string]$TenantId = "05153353-85ec-4c61-8bd6-6819cdf3789a",
  [string]$ClientId = "5248bc00-c34e-48fe-aa8d-660833f9b0a3",
  [string]$Endpoint = "https://graph.microsoft.com/v1.0/servicePrincipals/8f1f16c3-dc0f-45f4-b706-619b42819a09/synchronization/jobs/API2AD.0515335385ec4c618bd66819cdf3789a.1f775816-e0ed-4004-baa7-83b9d577317d/bulkUpload"
)
$secret = Read-Host "Client secret" -AsSecureString
$plain  = [System.Net.NetworkCredential]::new("", $secret).Password

$token = (Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Body @{
  client_id = $ClientId; client_secret = $plain
  scope = "https://graph.microsoft.com/.default"; grant_type = "client_credentials"
}).access_token

$ops = foreach ($r in Import-Csv $CsvPath) {
  @{
    method = "POST"; bulkId = [guid]::NewGuid().Guid; path = "/Users"
    data = @{
      schemas     = @("urn:ietf:params:scim:schemas:core:2.0:User",
                      "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User")
      externalId  = $r.EmployeeId
      userName    = $r.UserName
      name        = @{ givenName = $r.FirstName; familyName = $r.LastName }
      displayName = $r.DisplayName
      title       = $r.JobTitle
      active      = ($r.Status -eq "Active")
      "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = @{
        employeeNumber = $r.EmployeeId; department = $r.Department }
    }
  }
}
$body = @{ schemas = @("urn:ietf:params:scim:api:messages:2.0:BulkRequest")
           Operations = @($ops); failOnErrors = $null } | ConvertTo-Json -Depth 10

$resp = Invoke-WebRequest -UseBasicParsing -Method Post -Uri $Endpoint `
  -Headers @{ Authorization = "Bearer $token" } -ContentType "application/scim+json" -Body $body
"Status $($resp.StatusCode). Track it at: $($resp.Headers.Location)"
