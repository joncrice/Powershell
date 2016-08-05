# This gets dumpster size for all mailboxes
#Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalDeletedItemSize -Descending | Select-Object DisplayName,TotalDeletedItemSize | Out-file

# This gets details of folder sizes for a user
#Get-MailboxfolderStatistics mhodes02 |ft name, ItemsInFolder, FolderSize -AutoSize

Include for AD

===

Get-ADGroupMember -identity "GROUPNAME" -Recursive | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName?

=======

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

=======

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

======

$strUserName = "Jrice05"
$strUser = get-qaduser -SamAccountName $strUserName
$strUser.memberof

=========

Get-AdUser -filter

=========

Get-ADUser -SearchBase "OU=Accounts,OU=RootOU,DC=Domain,DC=com" -Properties memberof | Where {$_.memberof -match "CTX" -and $users -contains $_.samaccountname } | ForEach

========

CN=TTS-ESS,OU=Servers,OU=Common Resources,DC=tufts,DC=ad,DC=tufts,DC=edu

========

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -SearchBase "CN=TTS-ESS,OU=Servers,OU=Common Resources,DC=tufts,DC=ad,DC=tufts,DC=edu" -Properties memberof | Where {$_.memberof -match "CTX" -and $users -contains $_.samaccountname } | ForEach

======

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and Get-ADGroupMember } –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

========

ForEach-Object {
 $GName = $_.Samaccountname
 $group = Get-ADGroup $GName\
 $group.Name

Get-ADGroupMember AS_D_Conf_mail | Select-object -ExpandProperty name | Get-ADUser | Select-Object Surname,GivenName

(Get-VIEvent -Start "2/10/2015 3:08 AM" -Finish "2/10/2015 3:09 AM" -Entity "ddc1-vb01esx009.dm.mckesson.com" | ? {$_.Key -eq '135790287'}).Info

(Get-VIEvent -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | ? $_.Key).Info

Get-VIEvent -Entity WPAWEBSTG01 -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | Select Key



(Get-VIEvent -Entity WPAWEBSTG01 -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | ? {$_.Key -eq "2433554"}).info

Get-VIEvent -Entity WPAWEBSTG01 -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | Select Key | ft -hide


Get-MsolUser -UserPrincipalName jrice05@tufts.edu | Select-Object -ExpandProperty Licenses | Select-Object -ExpandProperty ServiceStatus


$IP = $ENV:COMPUTERNAME
$RunEXE = 'c:\windows\notepad.exe'
# This code should work as it is....
$proc = ([WMICLASS]"\\$IP\ROOT\CIMV2:win32_process").Create($RunEXE)
While(Get-WmiObject Win32_Process -computername $ip -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
write-host 'Process stopped'

Import-Module ActiveDirectory
cd AD:
Get-ADUser -filter 'memberOf -RecursiveMatch "CN=TTS-ESS,OU=Servers,OU=Common Resources,DC=tufts,DC=ad,DC=tufts,DC=edu"' –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
Import-Module ActiveDirectory
cd AD:


get-adgroupmember "TTS-ESS" -recursive | % {
    $group=$_
    get-aduser $_ -Properties Employeeid | select @{n="Group";e={$group}},Name,SurName,GivenName,Employeeid
}

Import-Module ActiveDirectory
cd AD:

Get-ADGroupMember -identity TTS-ESS | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName?,msDS-UserPasswordExpiryTimeComputed


Connect-MsolService -Credential $Office365credentials
Get-MsolUser -UserPrincipalName nwakul01@tufts.edu | Select-Object -ExpandProperty Licenses

Get-MsolUser -UserPrincipalName jrice05@tufts.edu | Select-Object -ExpandProperty Licenses | Select-Object -ExpandProperty ServiceStatus

IMPORT-Module LocalAccount
$servers = "TABVMPSHR2", "TFTMVMPSF6", "WSISPRODFS01", "TFTMVMADMPROD", "TFTMVMADMPROD"
ForEach ($item in $servers ) {
Write-Output "===="
Write-Output $item
Write-Output "===="
Get-LocalGroupMember -Name "Administrators" -Computername $item
}

# Script to retrieve users whose passwords are set to never expire.

Import-Module ActiveDirectory
cd AD:

Get-ADUser -filter {memberOf "CN=Domain Users,CN=Users,DC=tufts,DC=ad,DC=tufts,DC=edu",  Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

#This gets the install GUID for EMC Networker
$Uninstall = Get-WmiObject -Class Win32_Product -ComputerName Tabvmesstest01 | Where-Object -FilterScript {$_.Name -eq "NetWorker"} | Format-List -Property IdentifyingNumber
Echo $Uninstall
$StrUninstall = $Uninstall | Out-String
$pos = $StrUninstall.IndexOf(":")
$rightPart = $StrUninstall.Substring($pos+1).Trim()
Echo $rightPart

