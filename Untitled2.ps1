﻿
# Output file name
$filename = "Cluster_Services_restart"
$filedate = get-date -Format yyyyMMdd-hhmmss 
$filedate = $filedate -replace '\s.+$'
$filename += $filedate
$filename += ".txt"

# create log of run
Start-Transcript -Path "c:\ClusterSVC_Restart\$filename"

$computers = @("tabvmexdag1mb05","tabvmexdag1mb04","tabvmexdag1mb03","tabvmexdag1mb01")
#$computers = @("TTSESSDO01")

Write-Output "------------------------------------------------"
Write-Output "Starting review of Exchange clutering services"
Write-Output "------------------------------------------------"
Write-Output ""
Write-Output ""


$TestService = {

foreach ($comp in $computers)
{
$ServiceName = "ClusSvc"
#$ServiceName = "bits"
$arrService = Get-Service -Computer $comp -Name $ServiceName
$Date = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
$Start = "Started "
$Started = " service is already started."
if ($arrService.Status -ne "Running"){
Start-Service $ServiceName
($Date + " - " + $Start + $ServiceName + $comp) | Out-file c:\ClusterSVC_Restart\serviceStart.txt -append
Write-Output "Had to restart service on $comp"
}

#Below for debugging
if ($arrService.Status -eq "Running"){ 
($Date + " - " + $ServiceName + $Started) | Out-file c:\ClusterSVC_Restart\serviceStart.txt -append
Write-Output "Service is already running"
}
}
Start-Sleep -Seconds 60
.$TestService
}

&$TestService

Stop-Transcript