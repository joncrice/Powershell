$Computers = @("COMPUTER1","COMPUTER2")

ForEach ($computername in $computers) {
    $ADMINS = ""
    Write-Host "====== Local Admins for $computername ======"
    $computername = $computername.toupper()
    $ADMINS = get-wmiobject -computername $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='administrators'""" | % {$_.partcomponent}

    foreach ($ADMIN in $ADMINS) {
                $admin = $admin -replace ".*Name=" 
                $admin = $admin -replace '"', ""
                write-host $ADMIN
    }#end for $admin
    }#end for $computername

