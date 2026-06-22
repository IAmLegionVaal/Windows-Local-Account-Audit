@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Invoke-WindowsLocalAccountAudit.ps1"
set "RC=%ERRORLEVEL%"
echo.
echo Windows Local Account Audit finished with exit code %RC%.
pause
exit /b %RC%
