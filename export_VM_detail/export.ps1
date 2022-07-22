#Variables
$vscs = "ホスト名"
$cred = Get-Credential -Credential "$env:USERDOMAIN\$env:USERNAME"
$Out_file = "出力先"

Connect-VIServer -Server $vscs -Credential $cred

Get-VM | Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N="GuestOS";E={$_.Guest.OSFullName}}, @{N="Datacenter";E={Get-Datacenter -VM $_ | Select -ExpandProperty Name}}, @{N="Second IP";E={@($_.guest.IPAddress[1])}}, ResourcePool |
Where-Object {($_.Name -like "p-*") -or ($_.ResourcePool -like "*prod*")} |
Export-Csv -NoTypeInformation $Out_file
