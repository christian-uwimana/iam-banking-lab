# Guest inventory through Microsoft Graph

Run in Graph Explorer on 27 October 2026, signed in as the lab administrator. Permission needed: User.Read.All.

```http
GET https://graph.microsoft.com/v1.0/users?$filter=userType eq 'Guest'&$select=displayName,mail,companyName,createdDateTime,externalUserState,accountEnabled
```

Result, 200 OK. The first four guests belong to earlier work in this shared lab tenant; their addresses are hidden here.

```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users(displayName,mail,companyName,createdDateTime,externalUserState,accountEnabled)",
  "value": [
    { "displayName": "Fred Mugabo (TEKNOWLEDGE GLOBAL LTD)", "mail": "(hidden)", "companyName": null, "createdDateTime": "2026-06-01T10:37:01Z", "externalUserState": "Accepted", "accountEnabled": true },
    { "displayName": "oliverr", "mail": "(hidden)", "companyName": null, "createdDateTime": "2026-06-25T08:53:16Z", "externalUserState": "PendingAcceptance", "accountEnabled": true },
    { "displayName": "carmela soprano", "mail": "(hidden)", "companyName": null, "createdDateTime": "2026-07-28T08:37:42Z", "externalUserState": "Accepted", "accountEnabled": true },
    { "displayName": "dragon bull", "mail": "(hidden)", "companyName": null, "createdDateTime": "2026-07-28T09:33:49Z", "externalUserState": "Accepted", "accountEnabled": true },
    { "displayName": "magie chris (External Auditor)", "mail": "magiechris96@gmail.com", "companyName": "Ndayisaba & Partners", "createdDateTime": "2026-10-27T01:14:24Z", "externalUserState": "Accepted", "accountEnabled": false }
  ]
}
```

What it shows:

- **The auditor is blocked:** `accountEnabled: false` after the monthly guest review denied further access.
- **Only the auditor has a company recorded:** the other four guests have no `companyName`, so nothing in the directory says which organisation they belong to.
- **A stale invitation:** "oliverr" has been `PendingAcceptance` since 25 June 2026, an invitation nobody accepted, which should be withdrawn.
