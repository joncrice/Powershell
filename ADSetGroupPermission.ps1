# This will grant read permission to the AD group specificied in each of the AD groups loaded from file.
# This uses the dsacls command (installed as part of RSAT)


import-module activedirectory  
CD AD:

Start-Transcript -Path "c:\temp\AdGroupUpdateLog.txt"

$ADGroups = Get-Content "c:\temp\adgroupstoupdate.txt"

ForEach ($ADGroup in $ADGroups) {

#dsacls.exe $ADGroup /G "TUFTS\CTL_TTS_CSS_EUC_AD_Read_Access" /I:T
$ADGroup

}

Stop-Transcript


