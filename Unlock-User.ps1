<#
.SYNOPSIS
    Unlock a users account in AD
.DESCRIPTION
    Unlock a users account in AD
.EXAMPLE
    PS C:\> Unlock-User -UsersAccount "AMS Bob" -UsersDomain "au" 
    or to unlock an account in your current domain
    PS C:\> Unlock-User -UsersAccount "AMS Bob"
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz

    to find accounts that are locked
    Search-ADAccount -LockedOut -UsersOnly | Select-Object Name, SamAccountName
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UsersAccount
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

.".\IncludePWL.ps1"

$Userinfo = Get-ADUser -Filter * -Properties LockedOut -Server $DomainController |
    Where-Object { $_.SAMAccountName -like "*$user*" } |
    Select-Object -Property SamAccountName, DistinguishedName, LockedOut |
    Out-GridView -PassThru

Write-Host

if ($Userinfo.SamAccountName){
    if ($Userinfo.lockedout -eq "True") {
        Write-Host -f red "Account locked"
        Write-Host
        Write-Host "Unlocking Account"
        Unlock-ADAccount -Identity $Userinfo.SamAccountName -Credential $Cred -Server $DomainController 
    } Else {
        Write-Host -f Green "Account is Not Locked out"
    }
    # Write-Output "$($Userinfo.SamAccountName)  $((Get-ADUser -Identity $Userinfo.SamAccountName -Server $DomainController -Properties LockedOut).LockedOut)"
}else{
    Write-Host -f red "No account selected"
    Write-Host
}

