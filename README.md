# Windows Local Account Audit

> **Testing note:** This was tested by me to be working. User experience may vary.

Included: `Invoke-WindowsLocalAccountAudit.ps1`

```powershell
.\Invoke-WindowsLocalAccountAudit.ps1
```

Creates read-only reports for local users, groups, administrator membership and local password policy.

Reports: `C:\Users\Public\Documents\WindowsLocalAccountAudits`

Exit codes: `0` success, `1` fatal error, `2` warnings.

Account reports can contain usernames and group membership. Review them before sharing. MIT License.
