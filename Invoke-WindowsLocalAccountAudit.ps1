<#
.SYNOPSIS
Creates a read-only audit of Windows local accounts and groups.
#>
[CmdletBinding()]
param([string]$OutputRoot="$env:PUBLIC\Documents\WindowsLocalAccountAudits")

Set-StrictMode -Version 2.0
$ErrorActionPreference='Stop'
$runPath=Join-Path $OutputRoot ("Accounts_{0}_{1}" -f $env:COMPUTERNAME,(Get-Date -Format 'yyyyMMdd_HHmmss'))
$warnings=New-Object System.Collections.Generic.List[string]

try{
    if($env:OS -ne 'Windows_NT'){throw 'Windows is required.'}
    New-Item $runPath -ItemType Directory -Force|Out-Null

    if(Get-Command Get-LocalUser -ErrorAction SilentlyContinue){
        Get-LocalUser|Select-Object Name,Enabled,Description,LastLogon,PasswordExpires,PasswordRequired,UserMayChangePassword,SID|
            Export-Csv (Join-Path $runPath 'LocalUsers.csv') -NoTypeInformation
        Get-LocalGroup|Select-Object Name,Description,SID|
            Export-Csv (Join-Path $runPath 'LocalGroups.csv') -NoTypeInformation

        $adminSid=New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
        $adminGroup=$adminSid.Translate([System.Security.Principal.NTAccount]).Value.Split('\')[-1]
        Get-LocalGroupMember -Group $adminGroup -ErrorAction Stop|
            Select-Object Name,ObjectClass,PrincipalSource,SID|
            Export-Csv (Join-Path $runPath 'LocalAdministrators.csv') -NoTypeInformation
    }else{
        $warnings.Add('Microsoft.PowerShell.LocalAccounts cmdlets are unavailable.')
        Get-CimInstance Win32_UserAccount -Filter 'LocalAccount=True'|
            Select-Object Name,Disabled,Lockout,PasswordExpires,PasswordRequired,SID,Status|
            Export-Csv (Join-Path $runPath 'LocalUsers.csv') -NoTypeInformation
    }

    net.exe accounts 2>&1|Out-File (Join-Path $runPath 'PasswordPolicy.txt')
    $warnings|Out-File (Join-Path $runPath 'Warnings.txt')

    Write-Host "[OK] Account audit created: $runPath" -ForegroundColor Green
    if($warnings.Count -gt 0){exit 2}else{exit 0}
}catch{Write-Error $_.Exception.Message;exit 1}
