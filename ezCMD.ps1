##################################################################################################################################################################
#Load required assemblies for script
##################################################################################################################################################################


#Load assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")
[void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationCore")
#Change Assembly Settings
[System.Windows.Forms.Application]::EnableVisualStyles()


##################################################################################################################################################################
#Define required variables
##################################################################################################################################################################


#Define Script Root Variable for compatibility
$env:root = $psscriptroot
#Define parent of script root in en environement variable
$env:parent = split-path -path $env:root -parent
#define script file constant
$scriptfilesconstant = @{

    ver = "\ver\ver.txt"
    ezcmd = "\ezCMD.exe"
    webdriver = "\libs\WebDriver.dll"
    selenium = "\modules\Selenium.psm1"
    settings = "\Settings.ini"
    icon = "\img\icon.ico"
    startbtnimg = "\img\startbtn.jpeg"
    lockbtnimg = "\img\lockbtn.jpeg"
    appbtnimg = "\img\appbtn.jpeg"
    batterybtnimg = "\img\batterybtn.jpeg"
    runbtnimg = "\img\runbtn.jpeg"

}
#define script files locations
$scriptfiles = @{

    ver = "$env:root\ver\ver.txt"
    ezcmd = "$env:root\ezCMD.exe"
    webdriver = "$env:root\libs\WebDriver.dll"
    selenium = "$env:root\modules\Selenium.psm1"
    settings = "$env:root\Settings.ini"
    icon = "$env:root\img\icon.ico"
    startbtnimg = "$env:root\img\startbtn.jpeg"
    lockbtnimg = "$env:root\img\lockbtn.jpeg"
    appbtnimg = "$env:root\img\appbtn.jpeg"
    batterybtnimg = "$env:root\img\batterybtn.jpeg"
    runbtnimg = "$env:root\img\runbtn.jpeg"

}
#Define master variable for synchronized use across Runspaces
$global:master = [hashtable]::Synchronized(@{})
$global:master.starttaskstate = $false
$global:master.batterytaskstate = $false
$global:master.locktaskstate = $false
$global:master.runtaskstate = $false
$global:master.rootfolder = $env:root
$global:master.ActiveProgressBarCounter = 0
#Define global variable for task checkbox selection state
$global:Tasks = [hashtable]::Synchronized(@{})
$global:Tasks.TotalTaskChecked = 0
$global:Tasks.TasksProgress = 0
$global:Tasks.sfcscannow = $false
$global:Tasks.chkdsk = $false
$global:Tasks.dism = $false
$global:Tasks.refreshgpu = $false
$global:Tasks.refreshexplorer = $false
$global:Tasks.refreshdns = $false
#define missing scriptfile paths and names
$missingscriptfiles = @{}
#define present scriptfile count
$presentscriptfilescount = 0
#define total script file count
$totalscriptfilescount = 0
#define active copying jobs counter
$copyjob = 0


##################################################################################################################################################################
#Define required functions
##################################################################################################################################################################


#define needed functions
#define function to check if user is connected to internet
function Get-InternetStatus {

    if (test-connection "google.com" -count 1 -quiet) {

        return $true

    } else {

        return $false

    }

}
#define function to prompt user for a folder location
function Get-FolderLocation {

    [cmdletbinding()]

	param (
	
		[parameter(mandatory=$true)]
		[string]$description

	)

    Add-Type -AssemblyName System.Windows.Forms

    $folderdialog = new-object System.Windows.Forms.FolderBrowserDialog

    $folderdialog.Description = $description

    $resultdialog = $folderdialog.Showdialog()

    if ($resultdialog -eq [System.Windows.Forms.Dialogresult]::OK) {

        $selectedpath = $folderdialog.Selectedpath

        return $selectedpath

    } else {

        return $false

    }

}
#define function to display YES/NO popup 
function Get-UserConfirmation {

    [cmdletbinding()]

	param (
	
		[parameter(mandatory=$false)]
		[string]$text1,

        [parameter(mandatory=$false)]
		[string]$text2,

        [parameter(mandatory=$false)]
		[string]$text3

	)

    $form = new-object System.Windows.Forms.Form
    $form.Text = 'ezCMD'
    $form.Size = new-object System.Drawing.Size(270,180)
    $form.MinimumSize = new-object System.Drawing.Size(270,180)
    $form.MaximumSize = new-object System.Drawing.Size(270,180)
    if (test-path -path $scriptfiles.icon) {

        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($scriptfiles.icon)

    }

    $label1 = new-object System.Windows.Forms.Label
    $label1.Location = new-object System.Drawing.Point(40,15)
    $label1.Size = new-object System.Drawing.Size(280,20)
    $label1.Text = $text1
    $form.Controls.Add($label1)

    $label2 = new-object System.Windows.Forms.Label
    $label2.Location = new-object System.Drawing.Point(40,35)
    $label2.Size = new-object System.Drawing.Size(280,20)
    $label2.Text = $text2
    $form.Controls.Add($label2)

    $label3 = new-object System.Windows.Forms.Label
    $label3.Location = new-object System.Drawing.Point(40,55)
    $label3.Size = new-object System.Drawing.Size(280,20)
    $label3.Text = $text3
    $form.Controls.Add($label3)

    $nobutton = new-object System.Windows.Forms.Button
    $nobutton.Location = new-object System.Drawing.Size(30,100)
    $nobutton.Size = new-object System.Drawing.Size(60,20)
    $nobutton.Text = "No"
    $form.Controls.Add($nobutton)

    $yesbutton = New-Object System.Windows.Forms.Button
    $yesbutton.Location = New-Object System.Drawing.Size(160,100)
    $yesbutton.Size = New-Object System.Drawing.Size(60,20)
    $yesbutton.Text = "Yes"
    $form.Controls.Add($yesbutton)

    $nobutton.Add_Click({

        new-variable -name yesnoanswer -value $($false) -scope Script -force
        $form.Close()

    })

    $yesbutton.Add_Click({

        new-variable -name yesnoanswer -value $($true) -scope Script -force
        $form.Close()

    })

    $form.Topmost = $true
    $form.Add_Shown({$form.Activate()})
    [void] $form.ShowDialog()

}
#define function for showing popup
function Show-InformationBox {

    [cmdletbinding()]

	param (
	
		[parameter(mandatory=$true)]
		[string]$message

	)

    [System.Windows.MessageBox]::Show($message, "ezCMD", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information, [System.Windows.MessageBoxResult]::None, [System.Windows.MessageBoxOptions]::DefaultDesktopOnly)

}
#define function for starting install-script 
function Get-InstallConditions {

    [cmdletbinding()]

	param (
	
		[parameter(mandatory=$true)]
		[string]$count

	)

    $count = $count - 1

    if ($count -le 0) {

        Show-InformationBox -message "Too many tries. Exiting ezCMD."

        exit

    } else {

        Show-InformationBox -message "In the next Menu, choose a location for the installation. Please do not install ezCMD directly to C: or in any Users folder to prevent issues with permissions."

        $scriptlocation = Get-FolderLocation -description "Where do you want to install ezCMD?"
            
        if (-not ($scriptlocation -eq $false)) {

            if (test-path -path $scriptlocation) {

                Install-Script -type "new" -path $scriptlocation

                $startingtasks.new = $true

            } else {

                Show-InformationBox -message "Invalid Path. Please select a valid path."

                Get-InstallConditions -count $count

                return

            }

        } else {

            Show-InformationBox -message "No path selected. Please select a valid path."            

            Get-InstallConditions -count $count

            return

        }

    }

}
#define function for reinstalling script or script components
function Install-Script {

    [cmdletbinding()]

	param (
	
		[parameter(mandatory=$true)]
		[string]$type,

        [parameter(mandatory=$false)]
		[string]$path

	)

    if ($type -eq "temp") {

        $internetstatus = Get-InternetStatus

        while ($internetstatus -eq $false) {

            Show-InformationBox -message "Please connect to internet then press: OK"

            $internetstatus = Get-InternetStatus

            start-sleep -Milliseconds 500

        }

        if ($internetstatus -eq $true) {

            if (-not (test-path -path "$env:root\temp")) {

                new-item -path "$env:root\temp" -itemtype directory -force

            }

            invoke-webrequest -uri "https://github.com/Frysix/ezCMD/archive/refs/heads/main.zip" -outfile "$env:root\temp\ezCMD.zip"

            if (test-path -path "$env:root\temp\ezCMD.zip") {

                expand-archive -path "$env:root\temp\ezCMD.zip" -destinationpath "$env:root\temp" -force

                remove-item -path "$env:root\temp\ezCMD.zip" -recurse -force

            }

        } else {

            Show-InformationBox -message "Did not connect to internet. The App will close when pressing: OK"

            exit

        }

    } elseif ($type -eq "new") {

        if (-not (test-path -path "$env:root\temp")) {

            Install-Script -type "temp"

        }

        if (test-path -path $path) {

            copy-item -path "$env:root\temp\ezCMD-main" -Destination $path -Recurse -Force
            
        }

        if (test-path -path "$env:root\temp") {

            remove-item -path "$env:root\temp" -recurse -force

        }

        if (test-path -path "$path\ezCMD-main\ezCMD.exe") {

            start-process -FilePath "$path\ezCMD-main\ezCMD.exe" -verb runas

            exit

        }

    } elseif ($type -eq "fix") {

        if (-not (test-path -path "$env:root\temp")) {

            Install-Script -type "temp"

        }

        foreach ($file in $missingscriptfiles.GetEnumerator()) {

            $constant = $scriptfilesconstant.Get_Item($file.Name)

            if (-not ($null -eq $constant)) {

                $destination = split-path -path $file.Value -parent

                $info = @{
                    
                    origin = "$env:root\temp\ezCMD-main\$constant"
                    destination = $destination

                }

                start-job -name $file.Name -ScriptBlock {

                    param($info)

                    if (-not (test-path -path $info.destination)) {

                        new-item -path $info.destination -ItemType directory -force

                    }

                    copy-item -path $info.origin -destination $info.destination

                } -ArgumentList (,$info)

                $copyjob = $copyjob + 1

            }

        }

        while ($copyjob -gt 0) {

            $jobs = get-job

            foreach ($job in $jobs) {

                if ($job.State -match "Completed") {

                    $copyjob = $copyjob - 1

                }

            }

            start-sleep -Seconds 1

        }

        if (test-path -path "$env:root\temp") {

            Remove-Item -path "$env:root\temp" -recurse -force

        }

        Show-InformationBox -message "ezCMD has fixed itself. The App will restart when you press: OK."

        start-process -FilePath "$env:root\ezCMD.exe" -verb runas

        exit

    }

}



##################################################################################################################################################################
#Starting procedure. Script verifies if all of its files are present and if the user has administrator priviledges.
##################################################################################################################################################################


#checks if user is admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    start-process -filepath "$env:root\ezCMD.exe" -verb runas

    exit

}


#verify if each script files is present
foreach ($file in $scriptfiles.GetEnumerator()) {

    $totalscriptfilescount = $totalscriptfilescount + 1

    if (-not (test-path -path $file.Value)) {

        $missingscriptfiles = $missingscriptfiles + @{$file.Name=$file.Value}

    } else {

        $presentscriptfilescount = $presentscriptfilescount + 1

    }

}


#verify what percentage of total files are present
#checks if there is exactly 1 file present
if ($presentscriptfilescount -le 1) {

    Get-UserConfirmation -text2 "No installation detected." -text3 "Do you want to install from scratch?"

    if ($yesnoanswer -eq $true) {

        Get-InstallConditions -count 4

    } else {

        Show-InformationBox -message "You chose not to install. Exiting ezCMD."

        exit

    }

}


#checks if some files are missing but not all
if ($presentscriptfilescount -ge 2) {

    if ($presentscriptfilescount -lt $totalscriptfilescount) {

        Get-UserConfirmation -text2 "Not all script files are present." -text3 "Do you want to fix installation?"

        if ($yesnoanswer -eq $true) {

            Install-Script -type "fix"

            $startingtasks.fix = $true

        } else {

            Get-UserConfirmation -text2 "You chose not to fix." -text3 "Do you want to install from scratch?"

            if ($yesnoanswer -eq $true) {

                Get-InstallConditions -count 4

            } else {

                Show-InformationBox -message "You chose not to install or fix. Exiting ezCMD."

                exit

            }

        }

    }

}


#Read the settings file



##################################################################################################################################################################
#Launching Main UI
##################################################################################################################################################################


#Create Main GUI Object
$MainGUI                         = New-Object system.Windows.Forms.Form
$MainGUI.ClientSize              = New-Object System.Drawing.Point(848,425)
$MainGUI.text                    = "ezCMD"
$MainGUI.TopMost                 = $true
$MainGUI.icon                    = $scriptfiles.icon
$MainGUI.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#424141")
$MainGUI.FormBorderStyle         = 'FixedSingle'
$MainGUI.MaximizeBox             = $false


#Create Start Button Object
$StartButton                     = New-Object system.Windows.Forms.Button
$StartButton.width               = 140
$StartButton.height              = 140
$StartButton.location            = New-Object System.Drawing.Point(5,255)
$StartButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$StartButton.BackGroundImage     = [System.Drawing.Image]::FromFile($scriptfiles.startbtnimg)
$StartButton.BackgroundImageLayout = 'Stretch'
$StartButton.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create App Button Object
$AppButton                     = New-Object system.Windows.Forms.Button
$AppButton.width               = 140
$AppButton.height              = 140
$AppButton.location            = New-Object System.Drawing.Point(5,115)
$AppButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$AppButton.BackGroundImage     = [System.Drawing.Image]::FromFile($scriptfiles.appbtnimg)
$AppButton.BackgroundImageLayout = 'Stretch'
$AppButton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create Battery Report Button Object
$BatteryReportButton                    = New-Object system.Windows.Forms.Button
$BatteryReportButton.width               = 68
$BatteryReportButton.height              = 68
$BatteryReportButton.location            = New-Object System.Drawing.Point(76,48)
$BatteryReportButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$BatteryReportButton.BackGroundImage     = [System.Drawing.Image]::FromFile($scriptfiles.batterybtnimg)
$BatteryReportButton.BackgroundImageLayout = 'Stretch'
$BatteryReportButton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

#Create Power Command Prompt Object
$LockButton                    = New-Object system.Windows.Forms.Button
$LockButton.width               = 68
$LockButton.height              = 68
$LockButton.location            = New-Object System.Drawing.Point(6,48)
$LockButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LockButton.BackGroundImage     = [System.Drawing.Image]::FromFile($scriptfiles.lockbtnimg)
$LockButton.BackgroundImageLayout = 'Stretch'
$LockButton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create DropDown Object for power choices
$PowerOptionsListBox                = New-Object System.Windows.Forms.ListBox
$PowerOptionsListBox.Location       = New-Object System.Drawing.Point(8,10)
$PowerOptionsListBox.width          = 100
$PowerOptionsListBox.Height         = 40
[void] $PowerOptionsListBox.Items.Add('Restart')
[void] $PowerOptionsListBox.Items.Add('Shutdown')
[void] $PowerOptionsListBox.Items.Add('Log Out')
[void] $PowerOptionsListBox.Items.Add('Uninstall ezCMD')


#Create Run Button Object
$RunButton                     = New-Object system.Windows.Forms.Button
$RunButton.width               = 30
$RunButton.height              = 30
$RunButton.location            = New-Object System.Drawing.Point(115,10)
$RunButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$RunButton.BackGroundImage     = [System.Drawing.Image]::FromFile($scriptfiles.runbtnimg)
$RunButton.BackgroundImageLayout = 'Stretch'
$RunButton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create Black border of left column Object
$LeftColumnBlackBorder           = New-Object system.Windows.Forms.Panel
$LeftColumnBlackBorder.height    = 400
$LeftColumnBlackBorder.width     = 150
$LeftColumnBlackBorder.location  = New-Object System.Drawing.Point(15,8)
$LeftColumnBlackBorder.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#161616")


#Create Main window black pannel Object
$MainWindowBlackPannel           = New-Object system.Windows.Forms.Panel
$MainWindowBlackPannel.height    = 343
$MainWindowBlackPannel.width     = 642
$MainWindowBlackPannel.location  = New-Object System.Drawing.Point(186,7)
$MainWindowBlackPannel.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#161616")


#Create Label Object to put at top of black pannel
$TopCheckBoxText                 = New-Object system.Windows.Forms.Label
$TopCheckBoxText.text            = 'Selected Tasks:'
$TopCheckBoxText.width           = 165
$TopCheckBoxText.height          = 30
$TopCheckBoxText.location        = New-Object System.Drawing.Point(15,15)
$TopCheckBoxText.Font            = New-Object System.Drawing.Font('Arial',16)
$TopCheckBoxText.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create Label Object for the selected task counter
$SelectedTaskCounter             = New-Object system.Windows.Forms.Label
$SelectedTaskCounter.text        = $global:Tasks.TotalTaskChecked
$SelectedTaskCounter.width       = 30
$SelectedTaskCounter.height      = 30
$SelectedTaskCounter.location    = New-Object System.Drawing.Point(175,15)
$SelectedTaskCounter.Font        = New-Object System.Drawing.Font('Arial',16)
$SelectedTaskCounter.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


#Create Progress Bar Object
$TaskProgressBar                 = New-Object system.Windows.Forms.ProgressBar
$TaskProgressBar.width           = 526
$TaskProgressBar.height          = 33
$TaskProgressBar.location        = New-Object System.Drawing.Point(187.50,371)
$TaskProgressBar.Style           = "Continuous"
$TaskProgressBar.Maximum         = 100
$TaskProgressBar.Value           = 0


#Create Settings Button Object
$SettingsButton                  = New-Object system.Windows.Forms.Button
$SettingsButton.text             = "Settings"
$SettingsButton.width            = 101
$SettingsButton.height           = 33
$SettingsButton.location         = New-Object System.Drawing.Point(728,371)
$SettingsButton.Font             = New-Object System.Drawing.Font('Arial',11)
$SettingsButton.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$SettingsButton.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#464646")


#Define CheckBox Objects
$CheckBox1                       = New-Object system.Windows.Forms.CheckBox
$CheckBox1.text                  = "Run: sfc/scannow"
$CheckBox1.AutoSize              = $true
$CheckBox1.width                 = 201
$CheckBox1.height                = 151
$CheckBox1.location              = New-Object System.Drawing.Point(15,60)
$CheckBox1.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox1.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$CheckBox2                       = New-Object system.Windows.Forms.CheckBox
$CheckBox2.text                  = "Run: chkdsk"
$CheckBox2.AutoSize              = $true
$CheckBox2.width                 = 201
$CheckBox2.height                = 151
$CheckBox2.location              = New-Object System.Drawing.Point(15,85)
$CheckBox2.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox2.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$CheckBox3                       = New-Object system.Windows.Forms.CheckBox
$CheckBox3.text                  = "Run: dism"
$CheckBox3.AutoSize              = $true
$CheckBox3.width                 = 201
$CheckBox3.height                = 151
$CheckBox3.location              = New-Object System.Drawing.Point(15,110)
$CheckBox3.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox3.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$CheckBox4                       = New-Object system.Windows.Forms.CheckBox
$CheckBox4.text                  = "Reset: GPU Drivers"
$CheckBox4.AutoSize              = $true
$CheckBox4.width                 = 201
$CheckBox4.height                = 151
$CheckBox4.location              = New-Object System.Drawing.Point(15,135)
$CheckBox4.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox4.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$CheckBox5                       = New-Object system.Windows.Forms.CheckBox
$CheckBox5.text                  = "Reset: Windows Explorer"
$CheckBox5.AutoSize              = $true
$CheckBox5.width                 = 201
$CheckBox5.height                = 151
$CheckBox5.location              = New-Object System.Drawing.Point(15,160)
$CheckBox5.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox5.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$CheckBox6                       = New-Object system.Windows.Forms.CheckBox
$CheckBox6.text                  = "Reset: DNS Config"
$CheckBox6.AutoSize              = $true
$CheckBox6.width                 = 201
$CheckBox6.height                = 151
$CheckBox6.location              = New-Object System.Drawing.Point(15,185)
$CheckBox6.Font                  = New-Object System.Drawing.Font('Arial',11)
$CheckBox6.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

#Define functions for repetitive additions and substractions
function Add-TotalTasks {

    $global:Tasks.TotalTaskChecked = $global:Tasks.TotalTaskChecked + 1

    $SelectedTaskCounter.text = $global:Tasks.TotalTaskChecked

}
function Remove-TotalTasks {

    $global:Tasks.TotalTaskChecked = $global:Tasks.TotalTaskChecked - 1

    $SelectedTaskCounter.text = $global:Tasks.TotalTaskChecked

}
#Define CheckBox Triggers
$CheckBox1.Add_CheckStateChanged({

    if ($CheckBox1.Checked) {

        $global:Tasks.sfcscannow = $true

        Add-TotalTasks

    } else {

        $global:Tasks.sfcscannow = $false

        Remove-TotalTasks

    }

})
$CheckBox2.Add_CheckStateChanged({

    if ($CheckBox2.Checked) {

        $global:Tasks.chkdsk = $true

        Add-TotalTasks

    } else {

        $global:Tasks.chkdsk = $false

        Remove-TotalTasks

    }

})
$CheckBox3.Add_CheckStateChanged({

    if ($CheckBox3.Checked) {

        $global:Tasks.dism = $true

        Add-TotalTasks

    } else {

        $global:Tasks.dism = $false

        Remove-TotalTasks

    }

})
$CheckBox4.Add_CheckStateChanged({

    if ($CheckBox4.Checked) {

        $global:Tasks.refreshgpu = $true

        Add-TotalTasks

    } else {

        $global:Tasks.refreshgpu = $false

        Remove-TotalTasks

    }

})
$CheckBox5.Add_CheckStateChanged({

    if ($CheckBox5.Checked) {

        $global:Tasks.refreshexplorer = $true

        Add-TotalTasks

    } else {

        $global:Tasks.refreshexplorer = $false

        Remove-TotalTasks

    }

})
$CheckBox6.Add_CheckStateChanged({

    if ($CheckBox6.Checked) {

        $global:Tasks.refreshdns = $true

        Add-TotalTasks

    } else {

        $global:Tasks.refreshdns = $false

        Remove-TotalTasks

    }

})


#Define All Button Clicks Triggers
$RunButton.Add_Click({

    if ($global:master.runtaskstate -eq $false) {

        $global:master.runtaskstate = $true

        $global:master.PowerOption = $PowerOptionsListBox.SelectedItem

        if ($global:master.PowerOption -eq 'Restart') {

            $MainGUI.Close()

            restart-computer -force

        } elseif ($global:master.PowerOption -eq 'Shutdown') {



        } else {

            $powershell = [powershell]::Create()
            $runspace = [runspacefactory]::CreateRunspace()
            $runspace.Open()

            $runspace.SessionStateProxy.SetVariable('master',$global:master)

            $powershell.Runspace = $runspace

            $null = $powershell.AddScript({

                if ($global:master.PowerOption -eq 'Log Out') {

                    

                } elseif ($global:master.PowerOption -eq 'Uninstall ezCMD') {



                } else {



                }

            })

            $null = Register-ObjectEvent -InputObject $powershell -EventName InvocationStateChanged -Action {

                $state = $EventArgs.InvocationStateInfo.State
            
                if ($state -in 'Completed', 'Failed') {
            
                    $powershell.EndInvoke($handle)
                    $powershell.Runspace.Dispose()

                }
            
            }

            $handle = $powershell.BeginInvoke()

        }

    }

})
$StartButton.Add_Click({

    if ($global:Tasks.TotalTaskChecked -gt 0) {

        if ($global:master.starttaskstate -eq $false) {

            $global:master.starttaskstate = $true

            #progressbar animation and setup
            $TaskProgressBar.Maximum = $global:Tasks.TotalTaskChecked
            $TaskProgressBar.Value = 0

            #start executing tasks
            if ($global:Tasks.sfcscannow) {



            }
           
        }

    } else {

        if ($global:master.starttaskstate -eq $false) {

            $global:master.starttaskstate = $true

            $powershell = [powershell]::Create()
            $runspace = [runspacefactory]::CreateRunspace()
            $runspace.Open()

            $runspace.SessionStateProxy.SetVariable('master',$global:master)

            $powershell.Runspace = $runspace

            $null = $powershell.AddScript({

                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationCore")

                [System.Windows.MessageBox]::Show("Please check a box before pressing start!", "ezCMD", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information, [System.Windows.MessageBoxResult]::None, [System.Windows.MessageBoxOptions]::DefaultDesktopOnly)

                $global:master.starttaskstate = $false

            })

            $null = Register-ObjectEvent -InputObject $powershell -EventName InvocationStateChanged -Action {

                $state = $EventArgs.InvocationStateInfo.State
        
                if ($state -in 'Completed', 'Failed') {
        
                    $powershell.EndInvoke($handle)
                    $powershell.Runspace.Dispose()

                }
        
            }

            $handle = $powershell.BeginInvoke()
        
        }

    }

})
$LockButton.Add_Click({

    if ($global:master.locktaskstate -eq $false) {

        $global:master.locktaskstate = $true

        $powershell = [powershell]::Create()
        $runspace = [runspacefactory]::CreateRunspace()
        $runspace.Open()

        $runspace.SessionStateProxy.SetVariable('master',$global:master)

        $powershell.Runspace = $runspace

        $null = $powershell.AddScript({

            & "C:\Windows\System32\cmd.exe" /c "control userpasswords2"

            $global:master.locktaskstate = $false

        })
    
        $null = Register-ObjectEvent -InputObject $powershell -EventName InvocationStateChanged -Action {

            $state = $EventArgs.InvocationStateInfo.State

            if ($state -in 'Completed', 'Failed') {

                $powershell.EndInvoke($handle)
                $powershell.Runspace.Dispose()

            }

        }

    }

    $handle = $powershell.BeginInvoke()

})
$SettingsButton.Add_Click({



})
$AppButton.Add_Click({



})
$BatteryReportButton.Add_Click({

    if ($global:master.batterytaskstate -eq $false) {

        $global:master.batterytaskstate = $true

        $powershell = [powershell]::Create()
        $runspace = [runspacefactory]::CreateRunspace()
        $runspace.Open()

        $runspace.SessionStateProxy.SetVariable('master',$global:master)

        $powershell.Runspace = $runspace

        $null = $powershell.AddScript({

            $root = $global:master.rootfolder

            set-location -path $root

            if (test-path -path "$root\battery-report.html") {

                remove-item -path "$root\battery-report.html" -recurse -force

            }

            & "C:\Windows\System32\cmd.exe" /c "powercfg /batteryreport"

            if (test-path -path "$root\battery-report.html") {

                & "C:\Windows\System32\cmd.exe" /c "start .\battery-report.html"

                $global:master.batterytaskstate = $false

            } else {

                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")
                [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationCore")

                [System.Windows.MessageBox]::Show("Could not find battery-report.html. An error has occured...", "ezCMD", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information, [System.Windows.MessageBoxResult]::None, [System.Windows.MessageBoxOptions]::DefaultDesktopOnly)

                $global:master.batterytaskstate = $false

            }

        })

    }
    
    $null = Register-ObjectEvent -InputObject $powershell -EventName InvocationStateChanged -Action {

        $state = $EventArgs.InvocationStateInfo.State

        if ($state -in 'Completed', 'Failed') {

            $powershell.EndInvoke($handle)
            $powershell.Runspace.Dispose()

        }

    }

    $handle = $powershell.BeginInvoke()

})


#Add Items in range to LeftColumnBlackBorder var
$LeftColumnBlackBorder.controls.AddRange(@($StartButton,$AppButton,$BatteryReportButton,$LockButton,$PowerOptionsListBox,$RunButton))
#Add Items in range to MainWindowBlackPannel var
$MainWindowBlackPannel.controls.AddRange(@($TopCheckBoxText,$SelectedTaskCounter,$CheckBox1,$CheckBox2,$CheckBox3,$CheckBox4,$CheckBox5,$CheckBox6))
#Add Items in range to the Main GUI Object
$MainGUI.controls.AddRange(@($LeftColumnBlackBorder,$MainWindowBlackPannel,$TaskProgressBar,$SettingsButton))


#Display Menu
[void]$MainGUI.ShowDialog()