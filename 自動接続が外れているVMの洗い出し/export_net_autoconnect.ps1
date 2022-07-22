#Variables
$cred = Get-Credential -Credential "$env:USERDOMAIN\$env:USERNAME"
#-------------------------------Change_here-------------------------------
$vscs = "ホスト名"
$Out_File = "C:\出力先"
#-------------------------------------------------------------------------
Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else {
Write-Host "Code is running as administrator, go on executing the script..." -ForegroundColor Green
}
#connect vCenter
Connect-VIServer -Server $vscs -Credential $cred
#ALL host check startconnect
Get-VM | Get-NetworkAdapter|select Parent , ConnectionState| Sort-Object -Property ConnectionState | Export-Csv -NoTypeInformation $Out_File
