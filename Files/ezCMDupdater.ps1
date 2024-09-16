$scriptpar1 = (split-path -path $psscriptroot -parent)
$scriptpar2 = (split-path -path $scriptpar1 -parent)
$scriptbreaker = "$scriptpar2\ezCMD-main"
$localver = (get-content -path $psscriptroot\ver\ver.txt)
if (test-path -path $scriptbreaker) {
copy-item -path "$psscriptroot\ezCMDtemp" -destination "$scriptpar2" -recurse -force
$localver | Out-File -FilePath "$scriptpar2\ezCMDtemp\ver.txt" -Encoding ASCII
start-process -filepath "$scriptpar2\ezCMDtemp\start.bat" -verb runas
} else {
if (test-path -path "$scriptpar2\ezCMDtemp") {
remove-item -path "$scriptpar2\ezCMDtemp" -recurse -force
start-process -filepath "$scriptpar1\ezCMD.bat" -verb runas
} else {
function googleping {
return (test-connection -computername "www.google.com" -count 1 -quiet)
}
if (googleping) {
$gitver = (invoke-webrequest -uri "https://github.com/Frysix/ezCMD/raw/main/Files/ver/ver.txt" -usebasicp | select-object -expandproperty content)
if ($gitver -eq $localver) {
$oldver = (get-content -path $psscriptroot\ver\oldver.txt)
$oldinstall = "$scriptpar2\ezCMD-$oldver"
if (test-path -path $oldinstall) {
remove-item -path "$scriptpar2\ezCMD-$oldver" -recurse -force
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
} else {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
} else {
$outdir = (join-path -path "$scriptpar2" -childpath "ezCMD-$gitver.zip")
$url = "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip"
Invoke-WebRequest -Uri $url -OutFile $outdir
Expand-Archive -path "$scriptpar2\ezCMD-$gitver.zip" -destinationpath "$scriptpar2"
rename-item -path "$scriptpar2\ezCMD-main" -newname "ezCMD-$gitver"
$localver | Out-File -FilePath "$scriptpar2\ezCMD-$gitver\Files\ver\oldver.txt" -Encoding ASCII
remove-item -path "$scriptpar2\ezCMD-$gitver.zip" -recurse -force
start-process -filepath "$scriptpar2\ezCMD-$gitver\ezCMD.bat" -verb runas
}
} else { 
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
}
}
}
}