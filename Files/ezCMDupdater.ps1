$scriptpar1 = (split-path -path $psscriptroot -parent)
$scriptpar2 = (split-path -path $scriptpar1 -parent)
function gping {
return (test-connection -computername "www.google.com" -count 1 -quiet)
}
if (gping) {
$gitver = (invoke-webrequest -uri "https://github.com/Frysix/ezCMD/raw/main/Files/ver/ver.txt" -usebasicp | select-object -expandproperty content)
$localver = (get-content -path $psscriptroot\ver\ver.txt)
if ($gitver -eq $localver) {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
} else {
$outdir = (join-path -path "$scriptpar2" -childpath "ezCMD-$gitver.zip")
$url = "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip"
Invoke-WebRequest -Uri $url -OutFile $outdir
Expand-Archive -path "$scriptpar2\ezCMD-$gitver.zip" -destinationpath "$scriptpar2"
rename-item -path "$scriptpar2\ezCMD-main" -newname "ezCMD-$gitver"
$localver | Out-File -FilePath "$scriptpar2\ezCMD-$gitver\Files\ver\oldver.txt" -Encoding ASCII
remove-item -path "$scriptpar2\ezCMD-$gitver.zip"
start-process -filepath "$scriptpar2\ezCMD-$gitver\ezCMD.bat" -verb runas
}
} else {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
$oldver = (get-content -path $psscriptroot\ver\oldver.txt)
remove-item -path "$scriptpar2\ezCMD-$oldver" 
}