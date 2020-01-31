$ErrorActionPreference = "SilentlyContinue"
$servers = Get-Content "D:\servers.txt"
$results = @()
foreach ($server in $servers) {
    $rec = "" | select ServerName, Cluster, Nodes, Active
    $rec.ServerName = $server
    $rec.Cluster = (Get-WmiObject -class MSCluster_Cluster -namespace "root\mscluster" -ComputerName $server).Name
    if ($rec.Cluster -ne $null){
        $rec.Nodes = (Get-WmiObject -class MSCluster_Node -namespace "root\mscluster" -computername $server | Select-Object -ExpandProperty Name)  -join "; "
        $rec.Active = (Get-WMIObject Win32_ComputerSystem -ComputerName $rec.Cluster | Select-Object Name).Name
    }
    $results += $rec
}

$fileName = "Get-ClusterDetails_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv"
$results | Export-Csv -path $fileName  -Encoding ascii -NoTypeInformation
Invoke-Item $fileName