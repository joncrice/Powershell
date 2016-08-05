$out = "TEST"
$machinename = "Tabvmesstest01"
$key = "Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon"
$valuename = "DefaultUserName"

$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $MachineName)
$regkey = $reg.opensubkey($key)
Write-host $regkey.getvalue($valuename)