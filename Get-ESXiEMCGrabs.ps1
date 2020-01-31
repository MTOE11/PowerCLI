# Config
Import-Module VMware.VimAutomation.Core
#$emcgrabFolder = "$PWD\EMC-ESXi-GRAB-1.3.7"
$emcgrabFolder = "$PWD\EMC-ESXi-GRAB-1.3.10"
$emcgrabExe = "$emcgrabFolder\emcgrab.exe"
$outputFolderBase = "$PWD\EMCGrabs_ESXiHost"
$rootPwd = 'PassWordHere'
$sb = {
	param ($emcgrabExe,
		$esxName,
		$rootPwd,
		$outputFolder
	)
	& "$emcgrabExe" -host $esxName -user root -password $rootPwd -outdir $outputFolder -quiet -legal -autoexec
}

Connect-VIServer <vCenterNameHere>


$esxs = Get-VMHost <HostnameHere>


foreach ($esx in $esxs) {
	$outputFolder = "$outputFolderBase\$(($esx | Get-Cluster).Name)\$($esx.Name)"
	mkdir $outputFolder -Force | Out-Null
	Invoke-Command -ScriptBlock $sb -ArgumentList $emcgrabExe, $esx.Name, $rootPwd, $outputFolder
}

# EOF