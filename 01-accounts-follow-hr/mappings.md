# Attribute mappings

The *API-driven provisioning to on-premises Active Directory* app needed two attribute-mapping changes before it worked for this lab. The lab domain is `corp.equitybankltd.lab` and the bank's top-level folder is `OU=EquityBankLtd`.

## 1. Logon name (sAMAccountName)

The default mapping copies the whole `userName` (for example `zmurenzi@corp.equitybankltd.lab`), which breaks Active Directory's 20-character limit for logon names, so every new account fails. This expression keeps only the part before the @ and cuts it to 20 characters. It applies **only during object creation**, so a logon name never changes after an account exists.

```text
Left(Item(Split([userName], "@"), 1), 20)
```

Result: `zmurenzi@corp.equitybankltd.lab` becomes `zmurenzi`.

## 2. Department folder (parentDistinguishedName)

This expression places each person in their department's folder, and moves them when HR changes their department. It applies **always**, which is what turns a department change in HR into a folder move in Active Directory.

```text
Switch([urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department],
  "OU=Users,OU=EquityBankLtd,DC=corp,DC=equitybankltd,DC=lab",
  "Operations", "OU=Operations,OU=Users,OU=EquityBankLtd,DC=corp,DC=equitybankltd,DC=lab",
  "Finance", "OU=Finance,OU=Users,OU=EquityBankLtd,DC=corp,DC=equitybankltd,DC=lab",
  "Human Resources", "OU=Human Resources,OU=Users,OU=EquityBankLtd,DC=corp,DC=equitybankltd,DC=lab")
```

## Matching

HR records are matched to existing accounts on `externalId` (HR employee ID) to Active Directory `employeeID`, with matching precedence 1. That's why re-sending an unchanged record updates the same account instead of creating a second one.
