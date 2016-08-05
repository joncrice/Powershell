# Update static DNS settings
$computer = get-content C:\temp\servers.txt
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |where{$_.IPEnabled -eq “TRUE”}

Foreach($NIC in $NICs) 
{
$DNSServers = “10.10.130.7",”10.10.130.6"
 $NIC.SetDNSServerSearchOrder($DNSServers)
 $NIC.SetDynamicDNSRegistration(“TRUE”)
}