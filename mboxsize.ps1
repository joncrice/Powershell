$userlist = get-mailboxdatabase -server tabvmexdag1mb06.tufts.ad.tufts.edu | get-mailbox -ResultSize "Unlimited"

foreach ($user in $userlist)

{

$useralias = $user.alias
#write-host $useralias

$usermbsize = Get-MailboxStatistics $user.displayname | select-object TotalItemSize

$usermbsize = $usermbsize.totalitemsize.value.toGB()

$out = $useralias + “,” + $usermbsize

write-host $out

$Out | Out-File C:\ptusers06.csv -Append

}

# This gets dumpster size for all mailboxes
#Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalDeletedItemSize -Descending | Select-Object DisplayName,TotalDeletedItemSize | Out-file

# This gets details of folder sizes for a user
#Get-MailboxfolderStatistics mhodes02 |ft name, ItemsInFolder, FolderSize -AutoSize