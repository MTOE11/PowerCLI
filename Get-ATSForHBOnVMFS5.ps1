#Query ATSForHBOnVMFS5 setting on a cluster

$vCenterList = @(
	"vCenterCollectionHere"
    )

Disconnect-VIServer * -Confirm:$false

foreach ($vCenter in $vCenterList) {
    Connect-VIServer -Server $vCenter
    $timestamp = get-date -f yyyyMMdd-HHmmss
    $outputFileExcel = ""
    $outputFileExcel = $vCenter + "_ATSForHBOnVMFS5_" + $timestamp +".xlsx"
    Write-Output = "Doing file $outputFileExcel"
    $AllHosts = ""
    $AllHosts = @()
        $AllHosts =  Get-VMHost | Where-Object {$_.ConnectionState -like "Connected" -or $_.ConnectionState -like 'Maintenance'}
    $length = $AllHosts.Count
    Write-Output "Total of host: $length"
    $AllInfo = ""
    $AllInfo = @()
    $counter=1
    foreach ($esxhost in $AllHosts) {
        Write-Output "Doing host $esxhost, server# $counter out of $length"
        $counter++
        $Info = "" | Select-Object VMHost,Status, DataCenter,Cluster,Setting, Value
        $tempOutput = Get-AdvancedSetting -Entity $esxhost -Name VMFS3.UseATSForHBOnVMFS5 | Select-Object Entity, Name, Value
        $Info.VMHost = $esxhost.Name
        $Info.Status = $esxhost.ConnectionState
        $Info.DataCenter = (($esxhost | Get-Datacenter).Name)
        $Info.Cluster = (($esxhost | Get-Cluster).Name)
        $Info.Setting = $tempOutput.Name
        $Info.Value = $tempOutput.Value
        $AllInfo += $Info
    }

    $AllInfo | Format-Table -AutoSize
    #$AllInfo | Out-GridView
    $AllInfo | Export-Excel -Path $outputFileExcel -TableName $vCenter -TableStyle  "Medium7" -FreezeTopRowFirstColumn -AutoSize
    Disconnect-VIServer * -Confirm:$false
}