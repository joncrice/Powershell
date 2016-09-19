
# Output file name
$filename = "O365ExchangeChanges"
$filedate = Get-date -Format u 
$filedate = $filedate -replace '\s.+$'
$filename += $filedate
$filename += ".txt"

# move log files in file system 
cd\
cd temp
del yesterday.txt
copy today.txt yesterday.txt
copy msEX* today.txt
copy msEX* O365Reports
del msEX*

# diff logs
Compare-Object (Get-Content c:\temp\today.txt) (Get-Content C:\temp\yesterday.txt) | Out-File $filename


#Send email message of diffs
$body = Get-Content -Path $filename -Raw

Send-MailMessage -To "Firstname Lastname <XXXXX@domain.com>" -From "Firstname Lastname <XXXXX@domain.com>" -Subject "Office 365 Exchange licensing change report" -Body $body -SmtpServer smtp.domain.com

