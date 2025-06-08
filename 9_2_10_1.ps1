
 $Res = 0
 $LastVidPid = ''
 $UsbDevices = Get-PnpDevice | Sort-Object InstanceId | Where-Object { $_.InstanceId -like '*usb\\vid_*' }
 Write-Host $UsbDevices.Count, 'USB devices'
 foreach ($d in $UsbDevices) {
 $InstParts = $d.InstanceId -split '&'
 if ($InstParts.Count -lt 2) { continue }
 $VidPid = $InstParts[0] + '&' + $InstParts[1]
 if ($VidPid -ne $LastVidPid) {
 # Consider all instances of this VID/PID
 $ThisDevice = $UsbDevices | Where-Object { $_.InstanceId -and $_.InstanceId.Contains($VidPid) }
 $HasPrint = $ThisDevice | Where-Object { $_.CompatibleID -and $_.CompatibleID.Contains('USB\\Class_07&SubClass_01&Prot_02') }
 if ($HasPrint) {
 # No need to block an update for device with USB print
 # Do nothing
 }
 else {
 $HasScan = $ThisDevice | Where-Object { $_.CompatibleID -and $_.CompatibleID.Contains('USB\\MS_COMP_SCAN') }
 if ($HasScan) {
 Write-Host 'Block update for:', $thisDevice[0].InstanceID
 $Res = 1
 break
 }

 $HasWinUSB = $ThisDevice | Where-Object { $_.CompatibleID -and $_.CompatibleID.Contains('USB\\MS_COMP_WINUSB') }
 if ($HasWinUSB) {
 Write-Host 'Block update for:', $thisDevice[0].InstanceID
 $Res = 1
 break
 }
 }
 $LastVidPid = $VidPid
 }
 }
 Write-Host 'Final result:', $Res
