# set error action setting to abort th script even if the error is non-terminating
$ErrorActionPreference = Stop

# Using Try/Catch/Finally for error handling
Try
{

# create log of run
Start-Transcript -Path "\\titan\uit$:\EI\ESS\Netwrkr_upg\EMC_Networker_Upgrade.log" -Append

# import list of target computers from TXT/CSV
$computers = Get-Content "\\titan\uit$:\EI\ESS\Netwrkr_upg\computers.txt"

Write-Host "------------------------------------------------"
Write-Host "Starting upgrade of EMC Networker client"
Write-Host "Target computer:" $comp
Write-Host "------------------------------------------------"
Write-Host ""
Write-Host ""

foreach ($comp in $computers)
{
   Write-Host "------------------------------------------------"
   Write-Host "Establish a PSSession with" $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""
   
   $remotesession = New-PSSession -ComputerName $comp

   Write-Host "------------------------------------------------"
   Write-Host "Uninstall old version of Networker"
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""
   
   Invoke-command -session $remotesession -ScriptBlock { 
   		 "msiexec /quiet /uninstall NetWorker"         }

   Write-Host "------------------------------------------------"
   Write-Host "Install the new version of Networker"
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""   
   
   Invoke-command -session $remotesession -ScriptBlock 
   		{ 
   		"\\titan:\Networker\8.2.2\networkr\setup.exe /S /v /qn /l*v $comp.log
		INSTALLLEVEL=100 NW_INSTALLLEVEL=100 INSTALLDIR=c:\Program Files\EMC NetWorker\nsr\ 
		NW_FIREWALL_CONFIG=0 STARTSVC=1 setuptype=Install"
		}
	#End the remote session
    Remove-PSSession -Session $remotesession

   Write-Host "------------------------------------------------"
   Write-Host "Copy the log to titan and the server list to" $comp
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""  
   
   Copy-Item "\\$comp\c$\Program Files\EMC NetWorker\nsr\$comp.log" -Destination \\Titan\logs\
   Copy-Item "\\Titan\install\networker\server.txt" -Destination "\\$comp\c$\Program Files\EMC NetWorker\nsr\" -Force
   

   Write-Host "------------------------------------------------"
   Write-Host "Restart networker service"
   Write-Host "------------------------------------------------"
   Write-Host ""
   Write-Host ""
   
   Invoke-Command -Computername $comp 
   		{
		Restart-Service networker
		}
}

}

Stop-Transcript

Catch

{
   $ErrorMessage = $_.Exception.Message
   $FailedItem = $_.Exception.ItemName
   Write-Host "------------------------------------------------"
   Write-Host "Error message: $ErrorMessage"
   Write-Host "------------------------------------------------"
   Write-Host "Filed Item: $FailedItem"
   Write-Host "------------------------------------------------" 
   Write-Host ""
   Write-Host ""
    
}

Finally

{

}