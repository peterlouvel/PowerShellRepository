cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 100% / 96 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 96
Set-ItemProperty -Path . -Name Win8DpiScaling -Value 1
