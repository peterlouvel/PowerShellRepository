
param(
    [Parameter(Mandatory=$true)]
    [string]$Username
)

Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $Username} | Remove-CimInstance