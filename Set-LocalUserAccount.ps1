<#
.SYNOPSIS
    Set Local User Password and create User if doesn't exist and adds user to the Administrators group
.DESCRIPTION
    Set Local User Password and create User if doesn't exist and adds user to the Administrators group
.EXAMPLE
    PS C:\> Set-LocalUserAccount  -UserName "Username" -Password "Password"
    
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
    ,[Parameter(Mandatory=$true)]
    [string]$Password
)

$CreateUser = $False
Try {
    $LocalUser = Get-LocalUser -Name "$UserName"
    if ($?)
    {
        Write-Host "$LocalUser - Account"
    }
    else {
        throw $error[0].Exception
    }
} 
Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    Write-Host " $UserName was not found here" -ForegroundColor Green
    $CreateUser = $True
} 
Catch {
    Write-Host "error" -ForegroundColor Green
}

$error.Clear()
Write-Host "done"
$PassWordConverted = ConvertTo-SecureString $Password -AsPlainText -Force
if ($CreateUser) {
    Write-Host "Ceating User $UserName with Password $Password"
    New-LocalUser "$UserName" -Password $PassWordConverted -FullName "$UserName" -Description "Created by script." -AccountNeverExpires -PasswordNeverExpires
} else {
    Write-Host "Updating User $UserName with Password $Password"
    Set-LocalUser -Name "$UserName" -Password $PassWordConverted -AccountNeverExpires -PasswordNeverExpires $True
}
Add-LocalGroupMember -Group "Administrators" -Member "$UserName"