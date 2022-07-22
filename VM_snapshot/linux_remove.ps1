Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else {
Write-Host "Code is running as administrator, go on executing the script..." -ForegroundColor Green
}
#Variables
$vscs = "ホスト名"
$cred = Get-Credential -Credential "$env:USERDOMAIN\$env:USERNAME"
$reasonfor = Read-Host -Prompt "Enter the snapshot name:"
Connect-VIServer -Server $vscs -Credential $cred
#Menu bloc for VM Env Section choice#
$titlegposection = "Choose an Env Section"
$messagegposection = "Please select a option"
$C0 = New-Object System.Management.Automation.Host.ChoiceDescription "&1 Remove Snapshot Lab VMs - Linux"
$C1 = New-Object System.Management.Automation.Host.ChoiceDescription "&2 Remove Snapshot Dev VMs - Linux"
$C2 = New-Object System.Management.Automation.Host.ChoiceDescription "&3 Remove Snapshot Staging VMs - Linux"
$C3 = New-Object System.Management.Automation.Host.ChoiceDescription "&4 Remove Snapshot Prod VMs - Linux"
$optionsgposection = [System.Management.Automation.Host.ChoiceDescription[]]($C0, $C1, $C2, $C3)
$resultgposection = $host.ui.PromptForChoice($titlegposection, $messagegposection, $optionsgposection, 0)
switch ($resultgposection)
{
0 {$GSC = "GSC0"}
1 {$GSC = "GSC1"}
2 {$GSC = "GSC2"}
3 {$GSC = "GSC3"}
}
#---------------------------------------------------------------------
Sleep 2
switch ($GSC) {
GSC0 {### Lab env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "l-*") -or ($_.ResourcePool -like "*lab*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ -Name $reasonfor -ErrorAction SilentlyContinue | Remove-Snapshot -Confirm:$false -ErrorAction Continue }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "l-*") -or ($_.ResourcePool -like "*lab*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
      ; break}
GSC1 {### Dev env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "d-*") -or ($_.ResourcePool -like "*dev*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ -Name $reasonfor -ErrorAction SilentlyContinue | Remove-Snapshot -Confirm:$false -ErrorAction Continue }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "d-*") -or ($_.ResourcePool -like "*dev*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
      ; break}
GSC2 {### Staging env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "s-*") -or ($_.ResourcePool -like "*stag*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ -Name $reasonfor -ErrorAction SilentlyContinue | Remove-Snapshot -Confirm:$false -ErrorAction Continue }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "s-*") -or ($_.ResourcePool -like "*stag*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
    ; break}
GSC3 {### Prod env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "p-*") -or ($_.ResourcePool -like "*prod*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ -Name $reasonfor -ErrorAction SilentlyContinue | Remove-Snapshot -Confirm:$false -ErrorAction Continue
      Start-Sleep -Seconds 45 }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "p-*") -or ($_.ResourcePool -like "*prod*") -and ($_.Name -Notlike "*obic*")} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing trash operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
      ; break}
}
