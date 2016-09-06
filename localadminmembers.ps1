

ForEach ($computername in $computers) {
    $ADMINS = ""
    Write-Host "Local Admins for $computername"
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

