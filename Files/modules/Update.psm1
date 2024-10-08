

#this is a module that contains the updater's procedures

#check if update is available
function check-update {
	
	$gitver = get-gitver
	$localver = get-localver
	
	if ($localver -eq $gitver) {
		
		return "false"
		
	} else {
		
		return "true"
		
	}
	
}

#function to start the update process
function start-update {
	
	$parent0 = get-parent -dir "$psscriptroot"
	$parent1 = get-parent -dir "$parent0"
	$parent2 = get-parent -dir "$parent1"
	$gitver = get-gitver
	
	new-item -path "$parent2\temp" -itemtype directory
	
	web-install -url "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip" -path "$parent2\temp\update.zip"
	
	rename-item -path "$parent2\temp\ezCMD-main" -newname "ezCMD-$gitver"
	
	$true | out-file -filepath "$parent2\temp\ezCMD-$gitver\Files\config\cleanup.txt" -encoding ascii
	$parent1 | out-file -filepath "$parent2\temp\ezCMD-$gitver\Files\config\oldinst.txt" -encoding ascii
	
	copy-item -path "$parent2\temp\ezCMD-$gitver" -destination "$parent2" -recurse -force
	
	start-process -filepath "$parent2\ezCMD-$gitver\ezCMD.bat" -verb runas
}

#function for the script to clean up after update
function clean-update {
	
	$parent3 = get-parent -dir "$psscriptroot"
	$parent4 = get-parent -dir "$parent3"
	$parent5 = get-parent -dir "$parent4"
	$oldinstallation = get-oldinst
	
	remove-item -path $oldinstallation -recurse -force
	remove-item -path "$parent5\temp" -recurse -force
	remove-item -path "$parent3\config\cleanup.txt" -recurse -force
	remove-item -path "$parent3\config\oldinst.txt" -recurse -force
	
	$false | out-file -filepath "$parent3\config\cleanup.txt" -encoding ascii
	
}

#function to clean updates made from v0.09
function cleanold-update {
	pause
	$Files = get-parent -dir "$psscriptroot"
	$ezCMD = get-parent -dir "$Files"
	$Base = get-parent -dir "$ezCMD"
	
	remove-item -path "$Base\ezCMD-TEMP" -recurse -force
	remove-item -path "$Files\config\wasupdated.txt" -recurse -force
	
	
}