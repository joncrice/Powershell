﻿import-module activedirectory  
CD AD:

Start-Transcript c:\temp\audit.txt
Write-Output "====== Domain Admins ======"
Get-ADGroupMember -identity "Domain Admins"| Select-object -ExpandProperty name

Write-Output "====== Exchange Organization Administrators ======"
Get-ADGroupMember -identity "Exchange Organization Administrators"| Select-object -ExpandProperty name

Write-Output "====== CTL_TCCS_MIS_DBA ======"
Get-ADGroupMember -identity "CTL_TCCS_MIS_DBA"| Select-object -ExpandProperty name

Write-Output "====== CTL_TCCS_MIS_DBA ======"
Get-ADGroupMember -identity "CTL_TCCS_MIS_DBA"| Select-object -ExpandProperty name

Write-Output "====== TTS-ESS ======"
Get-ADGroupMember -identity "TTS-ESS"| Select-object -ExpandProperty name


$Computers = @("TABVMPSHR2","TFTMVMPSF6", "WSISPRODFS01","TFTMVMAWAPROD","TFTMVMADMPROD")


ForEach ($computername in $computers) {
    $ADMINS = ""
    Write-Output "====== Local Admins for $computername ======"
    $computername = $computername.toupper()
    $ADMINS = get-wmiobject -computername $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='administrators'""" | % {$_.partcomponent}
    #write-host $ADMINS
    foreach ($ADMIN in $ADMINS) {
                $admin = $admin -replace ".*Name=" 
                $admin = $admin -replace '"', ""
                write-host $ADMIN
                $objOutput = New-Object PSObject -Property @{
                    UserName = $admin.split("")[1]
                }#end object

    $objreport+=@($objoutput)
    #Write-Host $objreport
    }#end for
    }

Stop-Transcript