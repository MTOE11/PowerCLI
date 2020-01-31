$vCenter = @("vCenterHere")
Connect-VIServer $vCenter
$valuesToLookFor = @( 'Connected to*', '*is not responding')
$ESXiList = Get-Content "C:\Users\ESXiHostDisconnectedList.txt"
$AllEvents = $null
foreach ($ESXi in $ESXiList) {
    Write-Host "Doing $ESXi"
    $EventsFound = $null
    $EventsFound = Get-VIEvent (Get-VMHost $ESXi) -MaxSamples 1000 |
        Where-Object {($_.FullFormattedMessage -like 'Connected to*') -or ($_.FullFormattedMessage -like '*is not responding')} |
        Select-Object CreatedTime, FullFormattedMessage
    $AllEvents += $EventsFound
}

$AllEvents
$AllEvents | Out-GridView