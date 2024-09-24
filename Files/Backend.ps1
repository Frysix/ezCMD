
#this is where most powershell requests made by the main script are handled

#this is the frameworks on which the script will be able to sort and access different scripts
#from one file.

#import all modules available
import-module -name "$psscriptroot\modules\Utilities.psm1" -disablenamechecking
import-module -name "$psscriptroot\modules\Info.psm1" -disablenamechecking
import-module -name "$psscriptroot\modules\Update.psm1" -disablenamechecking
import-module -name "$psscriptroot\modules\Tasks.psm1" -disablenamechecking

#find taskname
$task = get-task

#sort by taskname to identify which task to start
#looking for systeminfo task
if ($task -eq "systeminfo") {
	
	#launches the systeminfo task
	task-systeminfo
	
#looking for powercopy select task
} elseif ($task -eq "pcsel") {
	
	#launches PowerCopy select task
	task-pcsel

#looking for powercopy copy task
} elseif ($task -eq "pcstart") {
	
	#launches PowerCopy start task
	task-pcstart
	
#looking for updateGPU task
} elseif ($task -eq "updategpu") {
	
	#launches updateGPU task
	task-updategpu

#looking for getpnp task
} elseif ($task -eq "getpnp") {
	
	#launches getpnp task
	task-getpnp
	
#looking for Massgrave Launcher task
} elseif ($task -eq "mgl") {
	
	#Launches Massgrave Launcher task
	task-mgl
	
#looking for Windows 11 requirements Bypass task
} elseif ($task -eq "11br") {
	
	#launches Win11 Bypass task
	task-11br
	
#add more tasks here
}