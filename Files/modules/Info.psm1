

#this is a module to retrieve needed informations

#function to get github version
function get-gitver {
	
	$gitver = invoke-webrequest -uri "https://github.com/Frysix/ezCMD/raw/main/Files/ver/ver.txt" -usebasicp | select-object -expandproperty content
	
	return $gitver
	
}

#function to get the local version of the script
function get-localver {
	
	$files = split-path -path $psscriptroot -parent
	
	$localver = get-content -path "$files\ver\ver.txt"
	
	return $localver
	
}

#function to get the old installation's version
function get-oldver {
	
	$files = split-path -path $psscriptroot -parent
	
	$oldver = get-content -path "$files\ver\oldver.txt"
	
	return $oldver
	
}

#function to get the old installation folder

function get-oldinst {
	
	$files = split-path -path $psscriptroot -parent
	
	$oldinst = get-content -path "$files\config\oldinst.txt"
	
	return $oldinst
	
}

#this function checks if auto update is enabled
function get-autoup {
	
	$files = split-path -path $psscriptroot -parent
	
	$autoup = get-content -path "$files\config\autoup.txt"
	
	return $autoup
	
}

#this function checks if the cleanup setting is enabled
function get-cleanup {
	
	$files = split-path -path $psscriptroot -parent
	
	$cleanup = get-content -path "$files\config\cleanup.txt"
	
	return $cleanup
	
}

#function to retrieve old updating formatting so the cleaning still works when updating from v0.09
function get-wasupdated {
	
	$files = split-path -path $psscriptroot -parent
	
	$wasupdated = get-content -path "$files\config\wasupdated.txt"
	
	return $wasupdated
	
}

#function to retrieve the taskname for Backend.ps1
function get-task {
	
	$files = split-path -path $psscriptroot -parent
	
	$taskname = get-content -path "$files\config\task.txt"
	
	return $taskname
	
}