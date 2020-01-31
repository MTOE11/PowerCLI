$serverlist = Get-Content "C:\servers.txt"
foreach($server in $serverlist)
{
#Get-WmiObject -ComputerName $server win32_operatingsystem | Select Status, CSName, Caption
Get-CimInstance -ComputerName $server -ClassName win32_operatingsystem | select csname, lastbootuptime
}