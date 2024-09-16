$updaterstatus = (get-content -path $psscriptroot\config\autoup.txt)
$statecompare = "true"
if ($updaterstatus -eq $statecompare) {
start-process -filepath "$psscriptroot\UpdateLauncher.bat" -verb runas
} else {
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas
}