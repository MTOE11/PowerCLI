#Extracted from: http://vmwareinsight.com/Tips/2017/1/5800904/Migrate-Roles-and-Permissions-from-one-vCenter-to-another-vCenter

$cond = {
    $_.IsSystem -eq $false -and (
        $_.Name -like '<ItemsTOAvoid>'
    )
}

$vCenterSource = "vCenterSourceHere"
$vCenterDestination = "vCenterDestinationHere"
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false
Connect-VIServer -Server $vCenterSource , $vCenterDestination
$roles = Get-VIRole -Server $vCenterSource | Where-Object $cond | Select-Object -Unique | Sort-Object Name

foreach ($role in $roles) {
    [string[]]$privilegesForRoleFromvCenterSource = Get-VIPrivilege -Role (Get-VIRole -Name $role -server $vCenterSource) | ForEach-Object {$_.id}
    New-VIRole -name $role -Server $vCenterDestination
    Set-VIRole -role (Get-VIRole -Name $role -Server $vCenterDestination) -AddPrivilege (Get-VIPrivilege -id $privilegesForRoleFromvCenterSource -server $vCenterDestination)
}