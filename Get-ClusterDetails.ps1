import-module failoverclusters
$ErrorActionPreference = "SilentlyContinue"
$servers = Get-Content "C:\servers.txt"
$results = @()

foreach ($server in $servers) {
    $rec = "" | select ServerName, Cluster, Nodes, Active
    $rec.ServerName = $server
    $rec.Cluster = (Get-Cluster -Name $server | Select-Object Name).Name
    if ($rec.Cluster -ne $null){
        $rec.Nodes = (Get-ClusterNode -Cluster $rec.Cluster | select -ExpandProperty Name) -join "; "
        $rec.Active = (Get-WMIObject Win32_ComputerSystem -ComputerName $rec.Cluster | Select-Object Name).Name
    }
    $results += $rec
}

#$results | ogv
$fileName = "Get-ClusterDetails_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv"
$results | Export-Csv -path $fileName  -Encoding ascii -NoTypeInformation
Invoke-Item $fileName