# Dormant-account report (Logic App)

The Logic App **Dormant_accounts** runs weekly, on Monday at 07:00 (UTC+2). It reads Microsoft Graph as the app registration **IAM Reporting**, which has two read-only application permissions, User.Read.All and AuditLog.Read.All, with admin consent. The client secret is stored in the Logic App and is not included here.

## 1. Read every user and their last sign-in (HTTP, Active Directory OAuth)

```http
GET https://graph.microsoft.com/v1.0/users?$select=displayName,userPrincipalName,employeeId,accountEnabled,signInActivity&$top=999
```

With more than 999 users, the response has an `@odata.nextLink` to follow for the next page.

## 2. Keep dormant accounts (Filter array on `body('HTTP')?['value']`)

```
@and(startsWith(coalesce(item()?['employeeId'], ''), '1004'), or(equals(item()?['signInActivity']?['lastSuccessfulSignInDateTime'], null), less(item()?['signInActivity']?['lastSuccessfulSignInDateTime'], addDays(utcNow(), -90))))
```

Keeps this project's people (employee IDs starting 1004) whose last successful sign-in is more than 90 days ago, or who have never signed in.

## 3. Build the CSV (Create CSV table on `body('Filter_array')`)

| Column | Value |
| --- | --- |
| Name | `item()?['displayName']` |
| Sign-in name | `item()?['userPrincipalName']` |
| Employee ID | `item()?['employeeId']` |
| Account enabled | `item()?['accountEnabled']` |
| Last sign-in | `coalesce(item()?['signInActivity']?['lastSuccessfulSignInDateTime'], 'Never')` |

## 4. Email it (Office 365 Outlook, Send an email V2)

To the IAM mailbox, subject "Dormant accounts report", with the table attached as dormant-accounts.csv.
