#this is the module to help with using selenium

#function to start selenium in with right settings
function se-start {

	$seoptions = new-object OpenQA.Selenium.Chrome.ChromeOptions
	$seoptions.AddExcludedArgument("enable-automation")
	$seoptions.AcceptInsecureCertificates = $true
	$seoptions.AddArgument("--safebrowsing-enable-enhanced-protection")
	$seoptions.AddUserProfilePreference("safebrowsing.disable_download_protection", $true)
	$seoptions.AddUserProfilePreference("safebrowsing.enabled", $true)

	return new-object OpenQA.Selenium.Chrome.ChromeDriver($seoptions)

}

#function to check if selenium is ready to go
function se-check {

	$files = get-parent -dir "$psscriptroot"

	$chromever = get-chromever

	$instchromedriv = $null

	if (test-path -path "$files\config\chromedriv.txt") {

		$instchromedriv = get-content -path "$files\config\chromedriv.txt"

	}

	if (-not ($chromever -eq $instchromedriv)) {

		if (test-path -path "$files\config\chromedriv.txt") {

			remove-item -path "$files\config\chromedriv.txt" -recurse -force

		}

		if (test-path -path "$files\libs\chromedriver.exe") {

			remove-item -path "$files\libs\chromedriver.exe" -recurse -force

		}

		web-install -url "https://storage.googleapis.com/chrome-for-testing-public/$chromever/win64/chromedriver-win64.zip" -path "$files\libs\ChromeDriver.zip"

		copy-item -path "$files\libs\chromedriver-win64\chromedriver.exe" -destination "$files\libs" -force

		$chromever | out-file -filepath "$files\config\chromedriv.txt" -encoding ascii

	}

	if (test-path -path "$files\libs\chromedriver-win64") {

		remove-item -path "$files\libs\chromedriver-win64" -recurse -force

	}

	$temp = get-item -path "C:\Windows\SystemTemp"

	$temp.Attributes = $temp.Attributes -band -bnot [System.IO.FileAttributes]::ReadOnly
	
}

#selenium Workfolder setup function
function se-setwork {

	[cmdletbinding()]
	
	param (
	
	[parameter(mandatory=$true)]
	[string]$path
	
	)

	if (($env:Path -split ';') -notcontains $path) {

		$env:Path += ";$path"

	}

	return $path

}

