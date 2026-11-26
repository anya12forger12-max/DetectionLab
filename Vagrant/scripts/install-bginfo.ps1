# Installs BGInfo on the host for easy identification
# Source: https://github.com/StefanScherer/adfs2
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing BGInfo..."
if (!(Test-Path 'c:\Program Files\sysinternals')) {
  New-Item -Path 'c:\Program Files\sysinternals' -type directory -Force -ErrorAction SilentlyContinue
}
$bginfoPath = 'c:\Program Files\sysinternals\bginfo.exe'
if (Test-Path $bginfoPath) {
  $signature = Get-AuthenticodeSignature -FilePath $bginfoPath
  if ($signature.Status -ne 'Valid' -or
      $signature.SignerCertificate.Subject -notmatch 'Microsoft Corporation') {
    Remove-Item $bginfoPath -Force
  }
}
if (!(Test-Path $bginfoPath)) {
  # SysInternals requires TLS 1.2. Never fall back to plaintext HTTP: this
  # binary is registered in an HKLM Run key and executes at every logon.
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  (New-Object Net.WebClient).DownloadFile('https://live.sysinternals.com/bginfo.exe', $bginfoPath)
  $signature = Get-AuthenticodeSignature -FilePath $bginfoPath
  if ($signature.Status -ne 'Valid' -or
      $signature.SignerCertificate.Subject -notmatch 'Microsoft Corporation') {
    Remove-Item $bginfoPath -Force
    throw "Refusing to use an unsigned or untrusted BGInfo executable: $bginfoPath"
  }
}

Copy-Item "c:\vagrant\resources\windows\background.bmp" 'c:\Program Files\sysinternals\background.bmp'

$vbsScript = @'
WScript.Sleep 15000
Dim objShell
Set objShell = WScript.CreateObject( "WScript.Shell" )
objShell.Run("""c:\Program Files\sysinternals\bginfo.exe"" /accepteula ""c:\Program Files\sysinternals\bginfo.bgi"" /silent /timer:0")
'@

$vbsScript | Out-File 'c:\Program Files\sysinternals\bginfo.vbs'

Copy-Item "C:\vagrant\scripts\bginfo.bgi" 'c:\Program Files\sysinternals\bginfo.bgi'

Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value 'wscript "c:\Program Files\sysinternals\bginfo.vbs"'
