

write-host "Hello my friend. Lets make your comp АХУИТЕЛЬНЫМ!" -ForegroundColor Green



write-host "Ставим софт..." -ForegroundColor Green


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
#get-disk | ? model -match ‘ssd’
$scriptpath = ($MyInvocation.MyCommand.Definition | split-path -parent)+'\'
$listfile=$scriptpath+'progs.txt'
$currentprogafile=$scriptpath+'current.txt'


Get-PackageProvider –Name Chocolatey –ForceBootstrap

#iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

Get-AppxPackage -AllUsers | where-object {$_.name –notlike "*store*"}| Remove-AppxPackage -ErrorAction SilentlyContinue


 $z = (Invoke-WebRequest 'https://chocolatey.org/install.ps1').content
 Set-Content -Path ($scriptpath+'install.ps1') -Value $z
 . ($scriptpath+'install.ps1')
 choco feature enable -n allowEmptyChecksums
 #$chocolist = chocolatey search
 #Set-Content -Path ($scriptpath+'chocoList.txt') -Value $chocolist

 choco install openssh -y

 . "C:\Program Files\OpenSSH-Win64\install-sshd.ps1"
 netsh advfirewall firewall add rule name="SSHD 22" dir=in action=allow protocol=TCP localport=22
 choco install vlc -y
 start /D "C:\Program Files (x86)\VideoLAN\VLC\" vlc.exe -I ntservice --ntservice-install --ntservice-name=VLC --ntservice-extraintf=dummy --ntservice-options="-I ntservice --extraintf=http --http-port=9090"
 sc start vlc

 $packagesToInstall = get-content -path $listfile
 
 
 for($i =0 ; $i -lt $packagesToInstall.count;$i++)
 {
 write-host ("Installing "+$packagesToInstall[$i]) 
 . cinst $packagesToInstall[$i] -y

 }

 write-host "Ставим обновления" -ForegroundColor Green
 get-wuinstall -acceptall -microsoftupdate -updatetype drivers
 get-wuinstall -acceptall -microsoftupdate -updatetype software


read-host -Prompt "Press enter"

exit
install-Module wuinstall.run