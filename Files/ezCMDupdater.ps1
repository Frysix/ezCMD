function gping {
return (test-connection -computername "www.google.com" -count 1 -quiet)
}
if (gping) {
$gitver = (invoke-webrequest -uri "https://github.com/Frysix/ezCMD/raw/main/Files/ver/ver.txt" -usebasicp | select-object -expandproperty content)
$localver = (get-content -path $psscriptroot\ver\ver.txt)
if ($gitver -eq $localver) {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
} else {
$scriptpar1 = (split-path -path $psscriptroot -parent)
$scriptpar2 = (split-path -path $scriptpar1 -parent)
$outdir = (join-path -path "$scriptpar2" -childpath "ezCMD-$gitver.zip")
$url = "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip"
Invoke-WebRequest -Uri $url -OutFile $outdir
Expand-Archive -path "$scriptpar2\ezCMD-$gitver.zip" -destinationpath "$scriptpar2"
rename-item -path "$scriptpar2\ezCMD-main" -newname "ezCMD-$gitver"

}
} else {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
}