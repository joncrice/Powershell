$testkeys = Get-VIEvent -Entity WPAWEBSTG01 -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | Select Key | ft -hide

foreach ($test in $testkeys)
{

(Get-VIEvent -Entity WPAWEBSTG01 -MaxSamples ([int]::MaxValue) -Start (Get-Date).AddMonths(-1) | Where { $_.GetType().Name -eq "TaskEvent" } | ? {$_.Key -eq "$test"}).info

}