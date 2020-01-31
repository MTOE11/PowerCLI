$HotfixToCopy = Get-Content "Hotfix to copy.txt"
#$HotfixToCopy
Set-Location -Path "E:\Hotfix"
New-Item -Name "<ServerName>" -ItemType directory
foreach ($KB in $HotfixToCopy){
    Get-ChildItem | Where-Object { $_.Name -like "*$KB*"} | Copy-Item -Destination "E:\Hotfix\<ServerName>"

}