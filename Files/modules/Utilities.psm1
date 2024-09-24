

#this is a module to add useful functions that may be used almost everywhere in the script

#function to help with the process of installing through direct links
function web-install {
	
	[cmdletbinding()]

	param (
	
		[parameter(mandatory=$true)]
		[string]$url,
		
		[parameter(mandatory=$true)]
		[string]$path
		
	)
	
	invoke-webrequest -uri $url -outfile $path
	
	if (test-path -path $path) {
		
		$extpath = split-path -path $path -parent
		
		expand-archive -path $path -destinationpath $extpath
		
		remove-item -path $path -recurse -force
		
	} else {
		
		$error = "Unable to find downloaded file"
		
		return $error
		
	}
	
}

#function to get any app by providing only the app's path
function get-app {
	
	[cmdletbinding()]
	
	param (
		
		[parameter(mandatory=$true)]
		[string]$testpath
		
	)
	
	return test-path -path $testpath
		
}

#function to check if user is connected to internet
function get-internet {
	
	if (test-connection "google.com" -count 1 -quiet) {
		
		return "true"
	
	} else {
		
		return "false"
		
	}
	
}

#function to get the parent dir of a specified dir
function get-parent {
	
	[cmdletbinding()]
	
	param (
	
	[parameter(mandatory=$true)]
	[string]$dir
	
	)
	
	$dirparent = split-path -path $dir -parent
	
	return $dirparent
	
}

#function to check if the active script as administrator rights
function is-admin {
	
	if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		
		return "false"
		
	} else {
		
		return "true"
		
	}
	
}

#function to launch the ezCMDmain.bat file
function start-main {
	
	$files = split-path -path $psscriptroot -parent
	
	start-process -filepath "$files\ezCMDmain.bat" -verb runas
	
}