Start-Transcript -Path "c:\users\XXXXX\Downloads\Samaccountname.txt"

#array to store result
$results = @()

# import list of emails TXT/CSV
$useremails = Get-Content "c:\users\XXXXX\Documents\box_users_06212016.txt"

Write-Host "------------------------------------------------"
Write-Host "Starting review of Box.com email accounts"
Write-Host "------------------------------------------------"
Write-Host ""
Write-Host ""


foreach ($useremail in $useremails)

{

#$samacct = get-aduser -Filter {mail -eq "$useremail"} | FT SamAccountName -HideTableHeaders
$samacct = get-aduser -Filter {mail -eq $useremail} | Select-Object -ExpandProperty SamAccountName
get-aduser -Filter {mail -eq $useremail} | Select-Object -ExpandProperty SamAccountName

# output the results to CSV.
$output = New-Object psobject
$output | Add-Member -MemberType noteproperty -Name Email $useremail
$output | Add-Member -MemberType noteproperty -Name SamAccount $samacct

$results += $output

#Computer $$MachineName
$results | Export-Csv c:\users\XXXXX\Downloads\box_users.csv



}

Stop-Transcript