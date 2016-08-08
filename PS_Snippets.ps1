# These require PowerShell module for Exchange 
# to add this to local PS session run ...  Add-PSsnapin Microsoft.Exchange.Management.PowerShell.E2010
# This gets dumpster size for all mailboxes
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalDeletedItemSize -Descending | Select-Object DisplayName,TotalDeletedItemSize | Out-file c:\temp\resultxxx.txt

# Just as above but only for those with litigation on hold.
Get-Mailbox -ResultSize Unlimited -Filter {LitigationHoldEnabled -eq $True} | Get-MailboxStatistics | Sort-Object TotalDeletedItemSize -Descending | Select-Object DisplayName,TotalDeletedItemSize | Out-file c:\temp\resultxxx.txt

# This gets details of folder sizes for a user
Get-MailboxfolderStatistics USER_UTLN |ft name, ItemsInFolder, FolderSize -AutoSize

# This force clears the exchange dumpster folders
Search-Mailbox -Identity USER_UTLN -SearchDumpsterOnly -DeleteContent 

# This gets dumpster size for all mailboxes
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalDeletedItemSize -Descending | Select-Object DisplayName,TotalDeletedItemSize | Out-file

# This gets details of folder sizes for a user
Get-MailboxfolderStatistics USER_UTLN |ft name, ItemsInFolder, FolderSize -AutoSize

# Get Litigation Hold Status of mailbox
Get-Mailbox USER_UTLN | fl LitigationHoldEnabled

=========

Active Directory Snippets
Requires AD Module https://blogs.msdn.microsoft.com/rkramesh/2012/01/17/how-to-add-active-directory-module-in-powershell-in-windows-7/

# Get information on group membership
Get-ADGroupMember -identity "GROUPNAME" -Recursive | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName

# Simpler one that just gets the UTLN
Get-ADGroupMember AS_D_Conf_mail | Select-object -ExpandProperty name

# Gets the domain password expiration date for domain users
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

#Get enabled domain users who have password set to never expire
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $True} | Select-Object -Property "Name", "GivenName", "Surname"

# Get password expiration for AD group
Get-ADUser -filter 'memberOf -RecursiveMatch "CN=GROUPNAME,OU=Servers,OU=Common Resources,DC=domain,DC=ad,DC=domain,DC=edu"' –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

=========

# This require the Office365 Module https://technet.microsoft.com/en-us/library/dn975125.aspx
# Good link for storing local credentials for Office 365 to automate connection in scripts: https://blogs.technet.microsoft.com/robcost/2008/05/01/powershell-tip-storing-and-using-password-credentials/

# Script for getting the O365 license status
Get-MsolUser -UserPrincipalName USER_UTLN@domain.com | Select-Object -ExpandProperty Licenses | Select-Object -ExpandProperty ServiceStatus

========

$IP = $ENV:COMPUTERNAME
$RunEXE = 'c:\windows\notepad.exe'
# This code should work as it is....
$proc = ([WMICLASS]"\\$IP\ROOT\CIMV2:win32_process").Create($RunEXE)
While(Get-WmiObject Win32_Process -computername $ip -filter "ProcessID='$($proc.ProcessID)'"){start-sleep -seconds 2}
write-host 'Process stopped'

========

get-adgroupmember "TTS-ESS" -recursive | % {
    $group=$_
    get-aduser $_ -Properties Employeeid | select @{n="Group";e={$group}},Name,SurName,GivenName
}

===========

# This requires loading a module https://gallery.technet.microsoft.com/scriptcenter/Local-Account-Management-a777191b
# This script goes through list of servers to get members of the locadmin accounts
IMPORT-Module LocalAccount
$servers = "SERVER1", "SERVER2", "SERVER3", "SERVER4", "SERVER5"
ForEach ($item in $servers ) {
Write-Output "===="
Write-Output $item
Write-Output "===="
Get-LocalGroupMember -Name "Administrators" -Computername $item
}

========

#Using Windows Management Instrumentation calls
#This gets the install GUID for EMC Networker
$Uninstall = Get-WmiObject -Class Win32_Product -ComputerName SERVERNAME | Where-Object -FilterScript {$_.Name -eq "NetWorker"} | Format-List -Property IdentifyingNumber
Echo $Uninstall
$StrUninstall = $Uninstall | Out-String
$pos = $StrUninstall.IndexOf(":")
$rightPart = $StrUninstall.Substring($pos+1).Trim()
Echo $rightPart

