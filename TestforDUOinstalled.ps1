# create log of run
Start-Transcript -Path "\\titan\uit$\ei\ess\Projects\Duoinstalled.txt"

# import list of target computers from TXT/CSV
#$computers = Get-Content "\\titan\uit$\ei\ess\Projects\computers.txt"
$computers = Get-Content "c:\temp\computers.txt"

# should we get the list of servers differently? - yes from VSphere Reports
# get the duo install status with registry call.
# log status and write to file

#$UnInstallString1 = "MsiExec.exe /x {386EFEBE-38A0-495E-B014-78C79B5864DC} /quiet /l*v c:\temp\$comp.v745.log"

Write-Host "------------------------------------------------"
Write-Host "Starting review of DUO installs on Windows Servers"
Write-Host "------------------------------------------------"
Write-Host ""
Write-Host ""

foreach ($comp in $computers)
{

   # Create temp dir off of C drive.
   #New-Item -Path "\\$comp\c`$" -Name temp -ItemType directory

   #Get-WmiObject -Class Win32_Product


   Write-Host "------------------------------------------------"
   Write-Host "Try various methods to uninstall old version of Networker on " $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""


    $HKLM = [UInt32] "0x80000002"
    $sSubKeyName = "SOFTWARE\Duo Security\DuoCredProv"
    $sValueName = "Version"
    $wmi = [wmiclass] "\\$comp\ROOT\DEFAULT:StdRegProv" 
    $version = $wmi.GetStringValue($HKLM, $sSubKeyName, $sValueName)

    Write-Host "Version is $version" 
  
   
   # Log output of install result.
   Out-File -FilePath c:\result.txt -Append -InputObject "$comp" 
}

Stop-Transcript
