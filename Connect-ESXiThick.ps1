$ESXiToConenct = Get-Content .\"ESXiServers.txt"
$Password = '<PasswordHere>'
if (Test-Path "C:\Program Files (x86)\VMware\Infrastructure\Virtual Infrastructure Client\Launcher") {
    Set-Location "C:\Program Files (x86)\VMware\Infrastructure\Virtual Infrastructure Client\Launcher"
    foreach ($ESXi in $ESXiToConenct) {
        .\VpxClient.exe -i -s $ESXi -u root -p $Password
    }
}
else {
    Write-Host "Thick client not found"
}G