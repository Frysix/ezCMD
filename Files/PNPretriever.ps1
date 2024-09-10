$gpuid = (Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty PNPDeviceID)
$gpuid | Out-File -FilePath "$psscriptroot\gen\misc\gpuid.txt" -Encoding ASCII