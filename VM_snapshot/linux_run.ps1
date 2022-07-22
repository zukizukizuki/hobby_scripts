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
$reasonfor = Read-Host -Prompt "Enter generic snapshot name"
#$reasonfor = "LinuxUpdate_April2020"
$checkchain = "vcsap|ssmca|vrops|cpmng|rhsat|aws|obic|unity|lb|grasv|umbva|untbn|srsve"
Connect-VIServer -Server $vscs -Credential $cred
#Menu bloc for VM Env Section choice#
$titlesnapsec = "Choose an Env Section"
$messagesnapsec = "Please select a option"
$C0 = New-Object System.Management.Automation.Host.ChoiceDescription "&1 Snapshot Lab VMs - Linux"
$C1 = New-Object System.Management.Automation.Host.ChoiceDescription "&2 Snapshot Dev VMs - Linux"
$C2 = New-Object System.Management.Automation.Host.ChoiceDescription "&3 Snapshot Staging VMs - Linux"
$C3 = New-Object System.Management.Automation.Host.ChoiceDescription "&4 Snapshot Prod VMs - Linux"
$C4 = New-Object System.Management.Automation.Host.ChoiceDescription "&5 Specific target - Linux"
$C5 = New-Object System.Management.Automation.Host.ChoiceDescription "&6 Filter based target(not case sensitive) - Linux"
$C6 = New-Object System.Management.Automation.Host.ChoiceDescription "&7 CSV based - Linux"
$C7 = New-Object System.Management.Automation.Host.ChoiceDescription "&8 Array list based - Linux"
$C8 = New-Object System.Management.Automation.Host.ChoiceDescription "&9 Retrieve CSV - Linux"
$optionssnapsec = [System.Management.Automation.Host.ChoiceDescription[]]($C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8)
$resultsnapsec = $host.ui.PromptForChoice($titlesnapsec, $messagesnapsec, $optionssnapsec, 0)
switch ($resultsnapsec)
{
0 {$GSC = "GSC0"}
1 {$GSC = "GSC1"}
2 {$GSC = "GSC2"}
3 {$GSC = "GSC3"}
4 {$GSC = "GSC4"}
5 {$GSC = "GSC5"}
6 {$GSC = "GSC6"}
7 {$GSC = "GSC7"}
8 {$GSC = "GSC8"}
}
#---------------------------------------------------------------------
Sleep 2
switch ($GSC) {
GSC0 {### Lab env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "l-*") -or ($_.ResourcePool -like "*lab*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync 
      }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "l-*") -or ($_.ResourcePool -like "*lab*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
      ; break}
GSC1 {### Dev env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "d-*") -or ($_.ResourcePool -like "*dev*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync 
      }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "d-*") -or ($_.ResourcePool -like "*dev*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
      ; break}
GSC2 {### Staging env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "s-*") -or ($_.ResourcePool -like "*stag*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync 
      }
    Start-Sleep -Seconds 2
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "s-*") -or ($_.ResourcePool -like "*stag*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
    ; break}
GSC3 {### Prod env
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "p-*") -or ($_.ResourcePool -like "*prod*") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Option abducted. Please use filter, array or CSV | $_" -ForegroundColor Red
    }
    ; break}
GSC4 {### Specific target based
    $target0 = Read-Host -Prompt "Enter VM Name"
    if(!(Get-VM -Name $target0 -ErrorAction Ignore)){
      Write-Warning -Message "This host is not present on the vcenter p-vcsap-001! aborting..."
      exit
    }
    elseif((Get-VM -Name $target0 | Select-Object {$_.Guest.OSFullName}) -like "*Windows*") {
      Write-Warning -Message "Your target is not part of Linux familly! aborting..."
      exit
    }
    elseif((Get-VM -Name $target0 | Select-Object {$_.Name}) -match $checkchain) {
      Write-Warning -Message "Your target is not supposed to be snapshotted! aborting..."
      exit
    }
    else {
      Write-Host "Processing snapshot operation on $target0" -ForegroundColor Red
      New-Snapshot -VM $target0 -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync
      Start-Sleep -Seconds 5
      Get-Snapshot -VM $target0 | format-list vm,name,created
    }
    ; break}
GSC5 {### Filter based
    $filter0 = Read-Host -Prompt "Enter desired filter (ex: p-*)"
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "$filter0") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync 
      }
    Start-Sleep -Seconds 2
    Get-VM |
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, ResourcePool |
    Where-Object {($_.Name -like "$filter0") -and ($_.Name -Notmatch $checkchain)} |
    Select-Object -ExpandProperty name |
    ForEach-Object { 
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      Get-Snapshot -VM $_ | format-list vm,name,created }
    ; break}
GSC6 {### CSV based
    Write-Host "Answer to the prompt box" -BackgroundColor DarkYellow
    Function Show-MsgBox ($Text,$Title="",[Windows.Forms.MessageBoxButtons]$Button = "OK",[Windows.Forms.MessageBoxIcon]$Icon="Information"){
    [Windows.Forms.MessageBox]::Show("$Text", "$Title", [Windows.Forms.MessageBoxButtons]::$Button, $Icon) | Where-Object{(!($_ -eq "OK"))}
    }
    If((Show-MsgBox -Title 'CSV Check' -Text 'Bear in mind that your CSVs must have at least one header called NAME, HOSTNAME or VM. PSComputerName would also work. Continue ?' -Button YesNo -Icon Warning) -eq 'Yes'){
      Write-Host "You confirmed your CSVs are correct, processing..." -BackgroundColor DarkRed
    }
    else {
      Write-Host "Modify your CSVs and start the script again, aborting..." -BackgroundColor DarkRed
    exit
    }
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Multiselect = $True
    Filter = 'CSV (*.csv)|*.csv'
    }
    $null = $FileBrowser.ShowDialog()
    $serverslist = $FileBrowser.FileNames
    $source0 = Import-Csv $serverslist
    $arrayInput = @()
    if ($source0.name) {$source0 | ForEach-Object {$arrayInput += $_.name}}
    if ($source0.hostname) {$source0 | ForEach-Object {$arrayInput += $_.hostname}}
    if ($source0.PSComputerName) {$source0 | ForEach-Object {$arrayInput += $_.PSComputerName}}
    if ($source0.vm) {$source0 | ForEach-Object {$arrayInput += $_.vm}}
    if ($source0.vms) {$source0 | ForEach-Object {$arrayInput += $_.vms}}
    $ServersArray = @($arrayInput) | sort -Unique | Where-Object {$_}
    $ServersArray | ForEach-Object {
      if(!(Get-VM -Name $_ -ErrorAction Ignore)){
        Write-Host "Current target: $_"
        Write-Warning -Message "This host is not present on the vcenter p-vcsap-001! aborting..."
        return
      }
      elseif((Get-VM -Name $_ | Select-Object {$_.Guest.OSFullName}) -like "*Windows*") {
        Write-Host "Current target: $_"
        Write-Warning -Message "Your target is not part of Linux familly! Recheck your list... Skip..."
        return
      }
      elseif((Get-VM -Name $_ | Select-Object {$_.Name}) -match $checkchain) {
        Write-Host "Current target: $_"
        Write-Warning -Message "This target is not supposed to be snapshotted! Skip..."
        return
      }
      else {
      Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
      New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync
      }
    }
    ; break}
GSC7 {### Array list based
    Write-Host "You will build the array, when complete, type the keyword END" -BackgroundColor DarkRed
    $arrayInput = @()
    do {
    $input = (Read-Host "Please enter hostname for the Array Value")
    if ($input -ne '') {$arrayInput += $input}
    }
    until ($input -eq 'end')
    #cleaning array
    $ServersArray = @($arrayInput | Where-Object { $_ -ne "end" }) | sort -Unique
    $ServersArray | ForEach-Object {
      if(!(Get-VM -Name $_ -ErrorAction Ignore)){
        Write-Host "Current target: $_"
        Write-Warning -Message "This host is not present on the vcenter p-vcsap-001! aborting..."
        return
      }
      elseif((Get-VM -Name $_ | Select-Object {$_.Guest.OSFullName}) -like "*Windows*") {
        Write-Host "Current target: $_"
        Write-Warning -Message "Your target is not part of Linux familly! Recheck your list... aborting..."
        return
      }
      elseif((Get-VM -Name $_ | Select-Object {$_.Name}) -match $checkchain) {
        Write-Host "Current target: $_"
        Write-Warning -Message "This target is not supposed to be snapshotted! Skip..."
        return
      }
      else {
        Write-Host "Processing snapshot operation on $_" -ForegroundColor Red
        New-Snapshot -VM $_ -name $reasonfor -Description "Created $(Get-Date)" -Quiesce -RunAsync
      }
  }
    ; break}
GSC8 {### Retreive CSVs
  Write-Host "You will retrieve a CSV file from the vCenter gathering information." -BackgroundColor DarkRed
  $eCSVe = Read-Host -Prompt "Please specify env (lab, dev, stg or prd)."
  if($eCSVe -eq 'lab'){
    $ePath = "$HOME\Documents\lin_machine_lab.csv"
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N="GuestOS";E={$_.Guest.OSFullName}}, @{N="Datacenter";E={Get-Datacenter -VM $_ | Select-Object -ExpandProperty Name}}, @{N="Second IP";E={@($_.guest.IPAddress[1])}}, ResourcePool |
    Where-Object {($_.Name -like "l-*") -or ($_.ResourcePool -like "*lab*")} |
    Export-Csv -NoTypeInformation $ePath -Force -Verbose
    Start-Sleep -Seconds 2
    $rCSV = Import-Csv -Path $ePath
    $noCheckchain = foreach($line in $rCSV){
        if($line.name -notmatch $checkchain){
            $line
        }
    }
    $noCheckchain | Export-Csv -Path $ePath -NoTypeInformation -Force -Verbose
  }
  elseif($eCSVe -eq 'dev') {
    $ePath = "$HOME\Documents\lin_machine_dev.csv"
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N="GuestOS";E={$_.Guest.OSFullName}}, @{N="Datacenter";E={Get-Datacenter -VM $_ | Select-Object -ExpandProperty Name}}, @{N="Second IP";E={@($_.guest.IPAddress[1])}}, ResourcePool |
    Where-Object {($_.Name -like "d-*") -or ($_.ResourcePool -like "*dev*")} |
    Export-Csv -NoTypeInformation $ePath -Force -Verbose
    Start-Sleep -Seconds 2
    $rCSV = Import-Csv -Path $ePath
    $noCheckchain = foreach($line in $rCSV){
        if($line.name -notmatch $checkchain){
            $line
        }
    }
    $noCheckchain | Export-Csv -Path $ePath -NoTypeInformation -Force -Verbose
  }
  elseif($eCSVe -eq 'stg') {
    $ePath = "$HOME\Documents\lin_machine_staging.csv"
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N="GuestOS";E={$_.Guest.OSFullName}}, @{N="Datacenter";E={Get-Datacenter -VM $_ | Select-Object -ExpandProperty Name}}, @{N="Second IP";E={@($_.guest.IPAddress[1])}}, ResourcePool |
    Where-Object {($_.Name -like "s-*") -or ($_.ResourcePool -like "*stag*")} |
    Export-Csv -NoTypeInformation $ePath -Force -Verbose
    Start-Sleep -Seconds 2
    $rCSV = Import-Csv -Path $ePath
    $noCheckchain = foreach($line in $rCSV){
        if($line.name -notmatch $checkchain){
            $line
        }
    }
    $noCheckchain | Export-Csv -Path $ePath -NoTypeInformation -Force -Verbose
  }
  elseif($eCSVe -eq 'prd') {
    $ePath = "$HOME\Documents\lin_machine_prod.csv"
    Get-VM | 
    Where-Object {$_.Guest.OSFullName -NotLike "*Windows*"} | 
    Select-Object Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}, @{N="GuestOS";E={$_.Guest.OSFullName}}, @{N="Datacenter";E={Get-Datacenter -VM $_ | Select-Object -ExpandProperty Name}}, @{N="Second IP";E={@($_.guest.IPAddress[1])}}, ResourcePool |
    Where-Object {($_.Name -like "p-*") -or ($_.ResourcePool -like "*prod*")} |
    Export-Csv -NoTypeInformation $ePath -Force -Verbose
    Start-Sleep -Seconds 2
    $rCSV = Import-Csv -Path $ePath
    $noCheckchain = foreach($line in $rCSV){
        if($line.name -notmatch $checkchain){
            $line
        }
    }
    $noCheckchain | Export-Csv -Path $ePath -NoTypeInformation -Force -Verbose
  }
    ; break}
}
