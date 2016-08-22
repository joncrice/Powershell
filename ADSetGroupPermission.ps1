# This will grant read permission to the AD group specified in each of the AD groups loaded from file.
# This uses the dsacls command (installed as part of RSAT)

import-module activedirectory  
CD AD:

Start-Transcript -Path "c:\temp\AdGroupUpdateLog.txt"

$ADGroups = Get-Content "c:\temp\adgroupstoupdate.txt"

ForEach ($ADGroup in $ADGroups) {

#dsacls.exe $ADGroup /G Tufts\CTL_TTS_CSS_EUC_AD_Read_Access:GR;;

$ADGroup

}

Stop-Transcript


