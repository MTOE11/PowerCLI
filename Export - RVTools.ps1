$sourceFolder = "C:\Users\User\Desktop\TestFolderLocal"
$destFolder = "C:\Users\User\Desktop\TestFolderRemote"

if (!(Test-Path $destFolder)) {
    New-Item -ItemType Directory -Force -Path $destFolder
}

$filesToTransfer = Get-ChildItem -Path $sourceFolder -Recurse

foreach ($file in $filesToTransfer) {
    $src = $file.FullName
    $dest = Join-Path -Path $destFolder -ChildPath $src

    if (!(Test-Path $dest)) {
        Copy-Item $src -Destination $destFolder
    }


}