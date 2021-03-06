# create log of run
#Start-Transcript -Path "\\titan\uit$\ei\ess\Projects\Duoinstalled.txt"
Start-Transcript -Path "c:\users\XXXXX\Downloads\Duoinstalled.txt"

#array to store result
$results = @()

# import list of target computers from TXT/CSV
#$computers = Get-Content "\\titan\uit$\ei\ess\Projects\computers.txt"
$computers = Get-Content "c:\users\XXXXX\Downloads\computers.txt"

Write-Host "------------------------------------------------"
Write-Host "Starting review of DUO installs on Windows Servers"
Write-Host "------------------------------------------------"
Write-Host ""
Write-Host ""

foreach ($comp in $computers)
{

# We are only using one hive of the registry (HKLM) but here is the references for all

$HKCR = 2147483648 #HKEY_CLASSES_ROOT
$HKCU = 2147483649 #HKEY_CURRENT_USER
$HKLM = 2147483650 #HKEY_LOCAL_MACHINE
$HKUS = 2147483651 #HKEY_USERS
$HKCC = 2147483653 #HKEY_CURRENT_CONFIG

if (test-connection $comp -quiet) 
{

$vinfo = "NOT INSTALLED"
# StdRegprov is used to get at registry keys and values https://msdn.microsoft.com/en-us/library/aa393664(v=vs.85).aspx
$reg = [wmiclass]"\\$comp\root\default:StdRegprov"

if ($reg) 

{

# reset the $vinfo value to null
$key = "SOFTWARE\Duo Security\DuoCredProv"
$value = "Version"
$vinfo = $reg.GetStringValue($HKLM, $key, $value) | Select-object -ExpandProperty svalue ## REG_SZ
"$comp,$vinfo" 
$reg = ""
}

else { "$comp,NOT ACCESSIBLE"
	$vinfo = "NOTE ACCESSIBLE"
	 }

}

else { "$comp,CANT CONNECT" 
	$vinfo = "CANT CONNECT"	
	}

$output = New-Object psobject
$output | Add-Member -MemberType noteproperty -Name Computer $comp
$output | Add-Member -MemberType noteproperty -Name Version $vinfo

$results += $output

#Computer $$MachineName
$results | Export-Csv c:\users\XXXXX\Downloads\DuoVersions.csv

 }

Stop-Transcript