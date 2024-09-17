#assing needed info to values
$oldinst = (get-content -path $psscriptroot\oldinst.txt)
$scriptpar1 = (split-path -path $psscriptroot -parent)
$newver = (get-content -path $psscriptroot\newver.txt)
$gitrepo = "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip"
$status = "true"

#download newer version from github repo
invoke-webrequest -uri $gitrepo -outfile "$psscriptroot\script.zip"

#exctract the downloaded archive
expand-archive -path "$psscriptroot\script.zip" -destinationpath "$psscriptroot"

#replace the 'main' by the version of the script in the name
rename-item -path "$psscriptroot\ezCMD-main" -newname "ezCMD-$newver"

#remove old installation
remove-item -path $oldinst -recurse -force 

#remove base wasupdated from new install
remove-item -path "$psscriptroot\ezCMD-$newver\Files\config\wasupdated.txt" -recurse -force

#outputting autocleaner condition to new install
$status | out-file -filepath "$psscriptroot\ezCMD-$newver\Files\config\wasupdated.txt" -encoding ascii

#copy new install to old install's parent directory
copy-item -path "$psscriptroot\ezCMD-$newver" -destination $scriptpar1 -recurse -force

#launch new install to start cleanup process
start-process -filepath "$scriptpar1\ezCMD-$newver\ezCMD.bat" -verb runas