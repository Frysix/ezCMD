# Function to check internet connection
function Test-InternetConnection {
    try {
        # Try to reach a reliable website
        $response = Test-Connection -ComputerName "www.google.com" -Count 1 -Quiet
        return $response
    } catch {
        return $false
    }
}
if (Test-InternetConnection) {
    Write-Output "Internet connection is available."

$localVersionFile = "$psscriptroot\ver\ver.txt"
$githubVersionUrl = "https://github.com/Frysix/ezCMD/tree/main/ezCMD/Files/ver/ver.txt"
$repositoryUrl = "https://github.com/username/repository/archive/refs/heads/main.zip"
$extractedFolder = "C:\Path\To\ExtractedFolder"
$ps1ScriptPath = "$extractedFolder\repository-main\script.ps1"

# Read local version number
$localVersion = Get-Content -Path $localVersionFile | Out-String
$localVersion = [version]$localVersion.Trim()

# Download the version file from GitHub
$webClient = New-Object System.Net.WebClient
$githubVersionContent = $webClient.DownloadString($githubVersionUrl)
$githubVersion = [version]$githubVersionContent.Trim()

# Compare version numbers
if ($githubVersion -gt $localVersion) {
    Write-Output "New version available: $githubVersion. Updating..."
    
    # Create a folder for the repository
    if (-Not (Test-Path -Path $extractedFolder)) {
        New-Item -Path $extractedFolder -ItemType Directory | Out-Null
    }
    
    # Download the repository
    $zipFile = "$extractedFolder\repository.zip"
    $webClient.DownloadFile($repositoryUrl, $zipFile)
    
    # Extract the ZIP file
    Expand-Archive -Path $zipFile -DestinationPath $extractedFolder -Force
    
    # Execute the PS1 script
    Start-Process powershell.exe -ArgumentList "-File `"$ps1ScriptPath`"" -NoNewWindow -Wait
    
    # Close the original PowerShell instance
    exit
} else {
    Write-Output "No update available. Current version: $localVersion"
    if (Test-Path $psscriptroot\ezCMDmain.bat) {
        Start-Process $psscriptroot\ezCMDmain.bat -Wait
    } else {
        Write-Output "ezCMD main file not found. Critical error, terminate task."
    }
    Exit
}

} else {
    Write-Output "No internet connection detected. Running ezCMD without updating."
    if (Test-Path $psscriptroot\ezCMDmain.bat) {
        Start-Process $psscriptroot\ezCMDmain.bat -Wait
    } else {
        Write-Output "ezCMD main file not found. Critical error, terminate task."
    }

    Exit
}
