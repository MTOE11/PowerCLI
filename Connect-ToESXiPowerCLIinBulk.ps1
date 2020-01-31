$ESXiToConenct = Get-Content .\"ESXiServers.txt"
$Passoword = '<PasswordHere>'
foreach ($ESXi in $ESXiToConenct) {
    Connect-VIServer -Server $ESXi -User root -Password $Passoword
}
