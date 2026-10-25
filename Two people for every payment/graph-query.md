# Checking the separation-of-duties rule through Microsoft Graph

Run in Graph Explorer on 25 October 2026, signed in as the lab administrator. `7cbf6801-3076-44fd-910c-58cd33227819` is the ID of the Payment Approval access package. Permission needed: EntitlementManagement.Read.All.

```http
GET https://graph.microsoft.com/v1.0/identityGovernance/entitlementManagement/accessPackages/7cbf6801-3076-44fd-910c-58cd33227819/incompatibleAccessPackages?$select=displayName,description
```

Result, 200 OK:

```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#Collection(microsoft.graph.accessPackage)",
  "value": [
    {
      "displayName": "Payment Initiation",
      "description": "Lets a payments officer key payments. Cannot be combined with Payment Approval."
    }
  ]
}
```

Payment Approval lists Payment Initiation as incompatible, the same as the portal setting (screenshot 9 in the [README](README.md)), so anyone holding Payment Initiation is refused Payment Approval (screenshot 8).
