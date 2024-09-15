$scriptpar1 = (split-path -path $psscriptroot -parent)
$localver = (get-content -path "$psscriptroot\ver.txt")
rename-item -path "$scriptpar1\ezCMD-main" -newname "ezCMD-$localver" -force
start-process -filepath "$scriptpar1\ezCMD-$localver\ezCMD.bat" -verb runas
