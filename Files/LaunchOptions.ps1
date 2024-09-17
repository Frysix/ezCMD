#check if script is running with admin priviledges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

#not admin assing parent folder to value
$scriptpar1 = (split-path -path $psscriptroot -parent)

#relaunch with admin prompt
start-process -filepath "$scriptpar1\ezCMD.bat" -verb runas

#script is admin continue as normal
} else {

#assing true to istrue
$istrue = "true"

#assing state of wasupdated to a value 
$wasupdated = (get-content -path $psscriptroot\config\wasupdated.txt)

#check if the script just updated
if ($wasupdated -eq $istrue) {

#just updated assing parent folder
$scriptpar1 = (split-path -path $psscriptroot -parent)
$scriptpar2 = (split-path -path $scriptpar1 -parent)

#remove TEMP directory
remove-item -path "$scriptpar2\ezCMD-TEMP" -recurse -force

#remove wasupdated from config
remove-item -path "$psscriptroot\config\wasupdated.txt" -recurse -force

#assing false to isfalse
$isfalse = "false"

#generate new statement for wasupdated
$isfalse  | out-file -filepath "$psscriptroot\config\wasupdated.txt" -encoding ascii

#launch newly updated ezCMD
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas

#the script was not updated continue
} else {

#assing auto update status information
$updatestatus = (get-content -path $psscriptroot\config\autoup.txt)

#check if update status is true
if ($updatestatus -eq $istrue) {
 
#check if user is connected to internet
function isconnected {
return (test-connection -computername "www.google.com" -count 1 -quiet)
}

#if user is connected continue
if (isconnected) {

#assing values to versions for comparing
$localver = (get-content -path $psscriptroot\ver\ver.txt)
$gitver = (invoke-webrequest -uri "https://github.com/Frysix/ezCMD/raw/main/Files/ver/ver.txt" -usebasicp | select-object -expandproperty content)

#compare versions and if they are equal start as normal
if ($gitver -eq $localver) {

#launch ezCMD with admin rights
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas

#the script is outdated launching update procedure
} else {

#assing values to parent folders
$scriptpar1 = (split-path -path $psscriptroot -parent)
$scriptpar2 = (split-path -path $scriptpar1 -parent)

#create working environnement
copy-item -path "$psscriptroot\ezCMD-TEMP" -destination "$scriptpar2" -recurse -force

#output version information and install foler in working environnement
$scriptpar1 | out-file -filepath "$scriptpar2\ezCMD-TEMP\oldinst.txt" -encoding ascii
$gitver | out-file -filepath "$scriptpar2\ezCMD-TEMP\newver.txt" -encoding ascii

#execute updater script
start-process -filepath "$scriptpar2\ezCMD-TEMP\startupdate.bat" -verb runas

}

#user is not connected to internet
} else {

#impossible to update launch ezCMD as admin
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas

}

#update status is false
} else {

#skip update and launch ezCMD as admin
start-process -filepath "$psscriptroot\ezCMDmain.bat" -verb runas

}

}

}