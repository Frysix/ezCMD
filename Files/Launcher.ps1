

#This is the script that handles the launch procedure of the main script

#import needed modules 
import-module -name "$psscriptroot\modules\Utilities.psm1" -disablenamechecking
import-module -name "$psscriptroot\modules\Info.psm1" -disablenamechecking
import-module -name "$psscriptroot\modules\Update.psm1" -disablenamechecking

#this function checks if the user is administrator
$admin = is-admin

#this if statement is there to check if the script needs to be restarted as admin
if ($admin -eq "false") {
	
	$parent1 = get-parent -dir "$psscriptroot"
	
	start-process -filepath "$parent1\ezCMD.bat" -verb runas
	
} else {
		
	#this function gets the auto updater setting's status
	$autoup = get-autoup

	#check if autoup is true or false
	if ($autoup -eq "false") {
		
		#autoup is false skip update process
		start-main
		
	} else {
		
		#autoup is true now checking if user has internet connected
		$internet = get-internet
		
		if ($internet -eq "false") {
			
			#internet is false start ezCMDmain.bat
			start-main
		
		} else {
			
			#user is connected to internet now checking if cleanup or install
			$cleanup = get-cleanup
			
			if ($cleanup -eq "true") {
				
				#starting cleanup function and starting main script after
				clean-update
				
				start-main
				
			} else {
				
				#this is a portion to make sure there is no problem when updating from v0.09
				$wasupdated = get-wasupdated
				
				if ($wasupdated -eq "true") {
					
					cleanold-update
					
					start-main
					
				} else {
					
					#no need for cleanup looking if user needs an update
					$check = check-update
					
					if ($check -eq "false") {
						
						#script is up to date start ezCMDmain.bat
						start-main
						
					} else {
						
						#script is not up to date start update procedure
						start-update
						
					}
					
				}
				
			}
			
		}
	
	}
	
}