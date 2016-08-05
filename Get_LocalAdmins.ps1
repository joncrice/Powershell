$domain_groups = "Domain Admins", "CTL_TCCS_MIS_DBA", "TTS_Server_Admins", "TTS-ESS", "Exchange Organization Administrators"
Write-Output "Domain Group Members Report" 

ForEach ($item in $domain_groups) {
Write-Output "Report on specified Domain Admin groups"
Write-Output "===="
Write-Output $item 
Write-Output "===="
# Get-ADGroupMember -Identity $item | Select -Property name 
Get-ADGroupMember $item | foreach {$_.name}
}

# Requires an external module (LocalAccount)
# https://gallery.technet.microsoft.com/scriptcenter/Local-Account-Management-a777191b

IMPORT-Module LocalAccount
$servers = "TABVMPSHR2", "TFTMVMPSF6", "WSISPRODFS01", "TFTMVMADMPROD", "TFTMVMADMPROD"
ForEach ($item in $servers ) {
Write-Output "Report Local Admin Accounts for specified servers"
Write-Output "===="
Write-Output $item
Write-Output "===="
Get-LocalGroupMember -Name "Administrators" -Computername $item
}


