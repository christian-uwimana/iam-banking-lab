# Identity and access management for a bank: hands-on projects

I'm Christian Uwimana. I built these projects to show how I would run identity and access management for a bank's institutional banking team, using Microsoft Entra ID P2 (formerly Azure AD Premium P2) and Active Directory. Each project stands on its own, with its own people, groups and story, and covers what a bank auditor checks: how access is granted, controlled, protected, monitored and removed.

| Project | In one line | Status |
| --- | --- | --- |
| [1. Accounts that follow HR](01-accounts-follow-hr/) | HR data creates, updates and disables accounts in Active Directory and the cloud, with no tickets. | Done |
| [2. Two people for every payment](02-two-people-for-every-payment/) | Payment access needs two approvals, expires in 90 days, and nobody can hold both maker and checker roles. | Done |
| 3. Locking the front door | MFA for all staff, Conditional Access tested in report-only mode before enforcement, and admin rights for two hours only. | Coming next |
| 4. Watching and checking | Alerts, a dashboard, quarterly access reviews and a weekly dormant-account report. | Coming next |
| 5. Third-party access | Outside auditors get approved, time-limited access that a review can shut off. | Coming next |

Each project has its design, step-by-step screenshot evidence, and the scripts and queries I used.

All work was done in my own test environment. It uses no real customer or employee data and is not affiliated with any bank.

**Contact:** magiechris96@gmail.com · +250787596124 · www.linkedin.com/in/uwimana-christian-505a23199
