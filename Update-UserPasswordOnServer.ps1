<#
.SYNOPSIS
    Create password in Credman for a server
.DESCRIPTION
    Create password in Credman for a server
.EXAMPLE
    PS C:\> Create-CredmanServerPassword -ServerName "-ServerName" -UserName "UserName"
    
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
    ,[Parameter(Mandatory=$true)]
    [string]$UserName
    ,[Parameter(Mandatory=$true)]
    [string]$PassWord
    
)

# Write-Host "WinNT://$ComputerName/$UserName"
$adminUser = [ADSI] "WinNT://$ComputerName/$UserName"
$adminUser.psbase.Username = $Cred.username
$adminUser.psbase.Password = $Cred.GetNetworkCredential().Password
$adminUser.SetPassword($PassWord)