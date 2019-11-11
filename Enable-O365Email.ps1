<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Enable-O365Email -User "user.name" -Domain "au"
    Creates the users mailbox on O365 and enables E3 licence 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$User
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain
)

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    }
} else {
    Write-Host "Domain should be AU or NZ"
    exit
}
Write-Host
Write-Host "Setup your Credentials for accessing the local exchange server" -ForegroundColor Cyan  
Write-Host $AdminAccount1

if ($stUserDomain -eq "au"){
    $EndAdmin = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $EndAdmin = "@edmi.co.nz"
} else {
    Write-Host "Your local account needs to be either AU or NZ" -ForegroundColor Red  
    exit
}

$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase + $End
# Write-Host "User eMail:  $Email"
Write-Host
Write-Host "Setup your Credentials for accessing the Office 365 systems" -ForegroundColor Cyan  
$Account = $stUserAccount + $EndAdmin
Write-Host $Account
if ($null -eq $O365CREDS){
    $O365CREDS   = Get-Credential $Account
} 
Write-Host
Write-Host "Connecting to Office 365" -ForegroundColor Green  
Connect-MSOLService -Credential $O365CREDS
If (Get-MsolUser -UserPrincipalName $Email -erroraction 'silentlycontinue') {
    Write-Host "User $Email Exits. Creating Mailbox on O365" -ForegroundColor Cyan  
} else {
    Write-Host "User $Email doesn't exist, wait till the user is on O365" -ForegroundColor White  
    exit
}
Write-Host
Write-Host "Connecting to the Local Exchange Server" -ForegroundColor Green  
# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null
$UserO365email = $UserLowerCase + "@edmi.mail.onmicrosoft.com"
Write-Host 
Write-Host "Setting up $UserLowerCase remote mailbox" -ForegroundColor Green  
Enable-RemoteMailbox -Identity $UserLowerCase  -DomainController $DomainController -RemoteRoutingAddress $UserO365email
Exit-PSSession
Remove-PSSession $Session1

Write-Host "------------------------------------------------------------------------------------------------"
Write-Host "Waiting a couple minutes for O365 email account to be created before enabling E3 licence." -ForegroundColor Cyan  
Write-Host "Not sure if the timeout is needed, or if we have to wait for the mailbox to sync back down to local AD." -ForegroundColor Cyan  
Write-Host "This just seems to work" -ForegroundColor Green  
Write-Host "------------------------------------------------------------------------------------------------"
Start-Sleep -s 15
Write-Host "----- 0:15"
Start-Sleep -s 15
Write-Host "----- 0:30"
Start-Sleep -s 15
Write-Host "----- 0:45"
Start-Sleep -s 15
Write-Host "----- 1:00"
Start-Sleep -s 15
Write-Host "----- 1:15"
Start-Sleep -s 15
Write-Host "----- 1:30"
Start-Sleep -s 15
Write-Host "----- 1:45"
Start-Sleep -s 15
Write-Host "----- 2:00"

# Give E3 licence to user
Connect-MSOLService -Credential $O365CREDS
Get-ADUser $UserLowerCase | Set-MsolUser  -UsageLocation $Domain                   # Sets the location (Country) of the user
Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:ENTERPRISEPACK"   # Gives E3 licence
