$filename = "msEXlicense"
$filedate = Get-date -Format u 
$filedate = $filedate -replace '\s.+$'
$filename += $filedate
$filename += ".txt"

$pass = get-content C:\users\XXXXX\cred.txt | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "XXXXX@domain.com",$pass

Start-Transcript -Path "c:\temp\$filename"

Connect-MsolService -Credential $credentials
#Get-MsolUser -All | where {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[7].ProvisioningStatus -eq "Success"}
#Get-MsolUser -UserPrincipalName XXXXX@domain.com | where {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[7].ProvisioningStatus -eq "Disabled"}
#Get-MsolUser -UserPrincipalName XXXXX@domain.com | Select-Object -ExpandProperty Licenses | Select-Object -ExpandProperty ServiceStatus

$users = Get-MsolUser -all | where {$_.isLicensed -eq "True"}
foreach ($user in $users) {
$status = ((get-msoluser -userprincipalname $user.UserPrincipalName).Licenses[0].ServiceStatus | ? {$_.ServicePlan.ServiceName -match “EXCHANGE”}).ProvisioningStatus
write-host $user.UserPrincipalName,"," $status}

# Output file name for changes
$filename1 = "O365ExchangeChanges"
$filedate1 = Get-date -Format u 
$filedate1 = $filedate1 -replace '\s.+$'
$filename1 += $filedate1
$filename1 += ".txt"

# copy log files in file system 
cd\
cd temp
del yesterday.txt
copy today.txt yesterday.txt
copy msEX* today.txt
copy msEX* O365Reports


# diff logs
Compare-Object (Get-Content c:\temp\today.txt) (Get-Content C:\temp\yesterday.txt) | Out-File $filename1


#Send email message of diffs
$body = Get-Content -Path $filename1 -Raw
Send-MailMessage -To "Firstname Lastname <XXXXX@domain.com>" -From "Firstname Lastname <XXXXX@domain.com>" -Subject "Office 365 Exchange licensing change report" -Body $body -SmtpServer smtp.domain.com

Stop-Transcript

# delete log file from temp dir 
cd\
cd temp
del msEX*