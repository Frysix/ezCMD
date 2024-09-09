# Define URLs and file paths
$versionFileUrl = "https://github.com/Frysix/ezCMD/blob/main/ezCMD/Files/ver/ver.txt"
$localVersionFile = "$psscriptroot\ver\ver.txt"
$updateFileUrl = "https://github.com/Frysix/ezCMD.git"
$updateDestination = "$psscriptroot"
$extractDestination = "$psscriptroot"
$batchFilePath = "$psscriptroot\ezCMDmain.bat"

function Test-InternetConnection {
    try {
        $response = Invoke-WebRequest -Uri "http://www.google.com" -UseBasicP
        return $true
    } catch {
        return $false
    }
}

function Get-FileContent {
    param (
        [string]$url
    )
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicP
        return $response.Content
    } catch {
        Write-Host "Error retrieving file from $url"
        return $null
    }
}

function Update-Software {
    param (
        [string]$updateUrl,
        [string]$destination,
        [string]$extractPath
    )
    try {
        Write-Host "Downloading update..."
        Invoke-WebRequest -Uri $updateUrl -OutFile $destination

        Write-Host "Extracting update..."
        Expand-Archive -Path $destination -DestinationPath $extractPath -Force

        Write-Host "Update complete."
        return $true
    } catch {
        Write-Host "Error updating software: $_"
        return $false
    }
}

# Check internet connection
if (Test-InternetConnection) {
    Write-Host "Internet is connected."

    # Get version from GitHub
    $remoteVersion = Get-FileContent -url $versionFileUrl
    if ($remoteVersion -eq $null) {
        Write-Host "Unable to retrieve version information from GitHub."
        exit
    }

    # Get local version
    if (Test-Path $localVersionFile) {
        $localVersion = Get-Content -Path $localVersionFile
    } else {
        Write-Host "Local version file does not exist."
        $localVersion = ""
    }

    # Check if update is needed
    if ($remoteVersion -ne $localVersion) {
        Write-Host "Update available. Local version: $localVersion, Remote version: $remoteVersion"

        # Perform update
        $updateSuccessful = Update-Software -updateUrl $updateFileUrl -destination $updateDestination -extractPath $extractDestination

        # Update local version file
        if ($updateSuccessful) {
            Set-Content -Path $localVersionFile -Value $remoteVersion
            Write-Host "Software updated successfully."

            # Run post-update batch file
            if (Test-Path $postUpdateBatchFilePath) {
                Write-Host "Running post-update batch file..."
                Start-Process -FilePath $postUpdateBatchFilePath -NoNewWindow -Wait
                Write-Host "Post-update batch file executed."
            } else {
                Write-Host "Post-update batch file not found at $postUpdateBatchFilePath."
            }
        } else {
            Write-Host "Update failed. No post-update action will be performed."
        }
    } else {
        Write-Host "No update needed. Local version is up-to-date."
    }
} else {
    Write-Host "No internet connection. Running batch file."

    # Run batch file
    if (Test-Path $batchFilePath) {
        Start-Process -FilePath $batchFilePath -NoNewWindow -Wait
        Write-Host "Batch file executed."
    } else {
        Write-Host "Batch file not found at $batchFilePath."
    }
}
