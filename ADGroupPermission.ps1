import-module activedirectory  
CD AD:

# This array will hold the report output.
$report = @()

$ADGroups = Get-ADObject -SearchBase (Get-ADDomain).DistinguishedName -LDAPFilter '(objectClass=group)' | Select-Object -ExpandProperty DistinguishedName

ForEach ($ADGroup in $ADGroups) {

$GroupName = get-acl -Path "AD:$ADGroup" | Select-Object -ExpandProperty Access | Where-Object {$_.IdentityReference -like "GROUPNAME" -and $_.ObjectType -notlike "00000000-0000-0000-0000-000000000000" } | Select-object -ExpandProperty IdentityReference
$Permission = get-acl -Path "AD:$ADGroup" | Select-Object -ExpandProperty Access | Where-Object {$_.IdentityReference -like "GROUPNAME" -and $_.ObjectType -notlike "00000000-0000-0000-0000-000000000000" } | Select-object -ExpandProperty ActiveDirectoryRights 


$output = New-Object psobject
$output | Add-Member -MemberType noteproperty -Name AdGroup $ADGroup
$output | Add-Member -MemberType noteproperty -Name CTLGroup $GroupName
$output | Add-Member -MemberType noteproperty -Name Permission $Permission

$GroupName
$Permission
$report.Count
$report += $output

}

$report | Export-Csv c:\temp\permissionreport.csv

