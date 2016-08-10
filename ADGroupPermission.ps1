CD AD:

# This array will hold the report output.
$report = @()

$ADGroups = Get-ADObject -SearchBase (Get-ADDomain).DistinguishedName -LDAPFilter '(objectClass=group)' | Select-Object -ExpandProperty DistinguishedName

ForEach ($ADGroup in $ADGroups) {



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

