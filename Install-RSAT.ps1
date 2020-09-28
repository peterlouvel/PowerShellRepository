# If you use a WSUS Server, disable access to it so you can install Remote Server Administration Tools
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -value 0
Get-Service wuauserv | Restart-Service
 
# Download all the Remote Server Administration Tools
Get-WindowsCapability -Online -Name RSAT*  | Add-WindowsCapability -Online
 
# Re-enable WSUS access on your system
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -value 1