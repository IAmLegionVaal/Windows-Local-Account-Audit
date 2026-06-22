# Windows Local Account Audit

> **Testing note:** This was tested by me to be working. User experience may vary.

## One-click use

1. Download and extract the repository.
2. Double-click `Run-OneClick.bat`.
3. The audit runs directly—there is no menu and no account is changed.
4. Review the exit code and reports under `C:\Users\Public\Documents\WindowsLocalAccountAudits`.

Included: `Invoke-WindowsLocalAccountAudit.ps1`

## PowerShell usage

```powershell
.\Invoke-WindowsLocalAccountAudit.ps1
```

Creates read-only reports for local users, groups, administrator membership and local password policy.

Exit codes: `0` success, `1` fatal error, `2` warnings.

Account reports can contain usernames and group membership. Review them before sharing. MIT License.
