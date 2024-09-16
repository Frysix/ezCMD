#getting and storing info into values
$pcmodel = (Get-WmiObject -Class Win32_ComputerSystem).Model
$os = (Get-WmiObject -Class Win32_OperatingSystem).caption
$osver = (Get-WmiObject -Class Win32_OperatingSystem).Version
$cpu = (Get-CimInstance -classname win32_processor).Name
$cpucore = (Get-CimInstance -classname win32_processor).NumberOfCores
$cputhreads = (Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty ThreadCount)
$totalthreads = ($cputhreads | Measure-Object -Sum).Sum
$cpuclock = (Get-CimInstance -classname win32_processor).MaxClockSpeed
$cpubrand = (Get-CimInstance -classname win32_processor).Manufacturer
$gpu = (Get-CimInstance win32_VideoController).Name
$qwMemorySize = (Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue)."HardwareInformation.qwMemorySize"
$vram = [math]::round($qwMemorySize/1GB)
$ramModules = Get-CimInstance -ClassName Win32_PhysicalMemory
$frequency = $null
$memoryAmount = 0
$brandName = $null
$numberOfSticks = $ramModules.Count
foreach ($module in $ramModules) {
    if (-not $frequency) {
        $frequency = $module.Speed
    }
    $memoryAmount += [math]::Round($module.Capacity / 1GB, 2)
    if (-not $brandName) {
        $brandName = $module.Manufacturer
    }
}
$motherboard = Get-CimInstance -ClassName Win32_BaseBoard
$mobomanufacturer = $motherboard.Manufacturer
$mobomodel = $motherboard.Product
#outputting values as single txt files
$pcmodel | Out-File -FilePath "$psscriptroot\gen\systeminfo\pcmodel.txt" -Encoding ASCII
$os | Out-File -FilePath "$psscriptroot\gen\systeminfo\os.txt" -Encoding ASCII
$osver | Out-File -FilePath "$psscriptroot\gen\systeminfo\osver.txt" -Encoding ASCII
$cpu | Out-File -FilePath "$psscriptroot\gen\systeminfo\cpu.txt" -Encoding ASCII
$cpucore | Out-File -FilePath "$psscriptroot\gen\systeminfo\cpucore.txt" -Encoding ASCII
$totalthreads | Out-File -FilePath "$psscriptroot\gen\systeminfo\cputhreads.txt" -Encoding ASCII
$cpuclock | Out-File -FilePath "$psscriptroot\gen\systeminfo\cpuclock.txt" -Encoding ASCII
$cpubrand | Out-File -FilePath "$psscriptroot\gen\systeminfo\cpubrand.txt" -Encoding ASCII
$gpu | Out-File -FilePath "$psscriptroot\gen\systeminfo\gpu.txt" -Encoding ASCII
$vram | Out-File -FilePath "$psscriptroot\gen\systeminfo\vram.txt" -Encoding ASCII
$brandname | Out-File -FilePath "$psscriptroot\gen\systeminfo\rambrand.txt" -Encoding ASCII
$memoryamount | Out-File -FilePath "$psscriptroot\gen\systeminfo\ramsize.txt" -Encoding ASCII
$frequency | Out-File -FilePath "$psscriptroot\gen\systeminfo\ramfrequency.txt" -Encoding ASCII
$mobomanufacturer | Out-File -FilePath "$psscriptroot\gen\systeminfo\mobomanufacturer.txt" -Encoding ASCII
$numberOfSticks | Out-File -FilePath "$psscriptroot\gen\systeminfo\ramsticknumber.txt" -Encoding ASCII
$mobomodel | Out-File -FilePath "$psscriptroot\gen\systeminfo\mobomodel.txt" -Encoding ASCII