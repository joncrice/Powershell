# create log of run
Start-Transcript -Path "\\titan\uit$\ei\ess\Netwrkr_upg\EMC_Networker_Upgrade.log"

# import list of target computers from TXT/CSV
$computers = Get-Content "\\titan\uit$\ei\ess\Netwrkr_upg\computers.txt"
#$computers = Get-Content "c:\temp\computers.txt"

$UnInstallString1 = "MsiExec.exe /x {386EFEBE-38A0-495E-B014-78C79B5864DC} /quiet /l*v c:\temp\$comp.v745.log"
$UnInstallString2 = "MsiExec.exe /x {BF9A19B5-D0E1-4397-BB8C-707C16C53D59} /quiet /l*v c:\temp\$comp.v7613.log"
$UnInstallString3 = "MsiExec.exe /x {5EC2C5EB-C818-4189-A27B-E9100669B307} /quiet /l*v c:\temp\$comp.v763.log"
$UnInstallString4 = "MsiExec.exe /x {5E86D2BE-13E2-4BB0-B3C8-FDAE96E91C4C} /quiet /l*v c:\temp\$comp.v753.log"
$UnInstallString5 = "MsiExec.exe /x {2BA74253-47F4-41CE-8F95-C4CC980E5828} /quiet /l*v c:\temp\$comp.v743.log"
$InstallString = 'C:\temp\InstallEMC\setup.exe /S /v"/qn /l*v c:\temp\comp.log INSTALLLEVEL=100"'

Write-Host "------------------------------------------------"
Write-Host "Starting upgrade of EMC Networker client"
Write-Host "------------------------------------------------"
Write-Host ""
Write-Host ""

foreach ($comp in $computers)
{

   # Create temp dir off of C drive.
   New-Item -Path "\\$comp\c`$" -Name temp -ItemType directory

   Write-Host "------------------------------------------------"
   Write-Host "Try various methods to uninstall old version of Networker on " $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""

   #Get install GUID for Networker. This process not being used but could replace serial de-install for each version below.
   $Uninstall = Get-WmiObject -Class Win32_Product -ComputerName $comp | Where-Object -FilterScript {$_.Name -eq "NetWorker"} | Format-List -Property IdentifyingNumber
   Echo $Uninstall
   $StrUninstall = $Uninstall | Out-String
   $pos = $StrUninstall.IndexOf(":")
   $rightPart = $StrUninstall.Substring($pos+1).Trim()
   Echo $rightPart
   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create("MsiExec.exe /x $rightPart /quiet /l*v c:\temp\$comp.test.log")
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version Test'

   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($UnInstallString1)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version 7.4.5'

   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($UnInstallString2)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version 7.6.1.3'

   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($UnInstallString3)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version 7.6.3.0'

   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($UnInstallString4)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version 7.5.3'

   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($UnInstallString5)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Uninstall process stopped for Version 7.4.3'
   
   # Rename 
   #Rename-Item -path ‘C:\program files\legato\nsr\res\nsrladb’ -newName ‘C:\program files\legato\nsr\res\nsrladb_old’
   Rename-Item -path "\\$comp\c`$\program files\legato\nsr\res\nsrladb" -newName "\\$comp\c`$\program files\legato\nsr\res\nsrladb_old"

   $DestinationDir = "\\$comp\c`$\temp\InstallEMC"
   Write-Host "------------------------------------------------"
   Write-Host "Copy install files to tempdir on" $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host "" 

   # Copy the new installer down to the target machine
   Copy-Item "\\titan\install$\Networker\8.2.2\networkr" -Destination $DestinationDir -Recurse

   Write-Host "------------------------------------------------"
   Write-Host "Install the new version of Networker on" $comp
   Write-Host $InstallString
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""   

   # Important note: if the destination folder already exists this install will fail.
   $proc = ([WMICLASS]"\\$comp\ROOT\CIMV2:Win32_Process").Create($InstallString)
   While(Get-WmiObject Win32_Process -computername $comp -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
   write-host 'Process stopped'
   
   Write-Host "------------------------------------------------"
   Write-Host "Copy the log to titan and the server list to" $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""  
   
   Copy-Item "\\$comp\c`$\Temp\comp.log" -Destination "\\titan\uit$\ei\ess\Netwrkr_upg\Install_Logs\$comp.log"
   Copy-Item "\\titan\uit$\ei\ess\Netwrkr_upg\servers.txt" -Destination "\\$comp\c`$\Program Files\EMC NetWorker\nsr\" -Force
   Copy-Item "\\titan\uit$\ei\ess\Netwrkr_upg\servers.txt" -Destination "\\$comp\c`$\Program Files\EMC NetWorker\nsr\servers" -Force
   Copy-Item "\\titan\uit$\ei\ess\Netwrkr_upg\servers.txt" -Destination "\\$comp\c`$\C:\Program Files\Legato\nsr\" -Force
   Copy-Item "\\titan\uit$\ei\ess\Netwrkr_upg\servers.txt" -Destination "\\$comp\c`$\C:\Program Files\Legato\nsr\servers" -Force
   
   Write-Host "------------------------------------------------"
   Write-Host "Restart networker services"
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""
   
   Get-Service -ComputerName $comp nsrexecd | Restart-Service
   Get-Service -ComputerName $comp nsrpm | Restart-Service

   # Log output of install result.
   Out-File -FilePath c:\installed.txt -Append -InputObject "$comp"
}

Stop-Transcript
