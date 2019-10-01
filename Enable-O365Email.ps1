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
# Write-Host $AdminAccount

if ($null -eq $Cred){
    $Cred = Get-Credential $AdminAccount
} 

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "NZBneDC5.nz.edmi.local"
} else {
    exit
}

$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase + $End
# Write-Host "User eMail:  $Email"

if ($null -eq $O365CREDS){
    $Account = $stUserAccount + $End
    $O365CREDS   = Get-Credential $Account
} 

Write-Host $Email

Connect-MSOLService -Credential $O365CREDS
If (Get-MsolUser -UserPrincipalName $Email -erroraction 'silentlycontinue') {
    Write-Host "User Exits. Creating Mailbox on O365"
} else {
    Write-Host "User Doesn't Exist, wait till the user is on O365"
    exit
}


# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null
$UserO365email = $UserLowerCase + "@edmi.mail.onmicrosoft.com"
Enable-RemoteMailbox -Identity $UserLowerCase  -DomainController $DomainController -RemoteRoutingAddress $UserO365email
Exit-PSSession
Remove-PSSession $Session1

# Write-Host "------------------------------------------------------------------------------------------------"
# Write-Host "Waiting a couple minutes for O365 email account to be created before enabling E3 licence." -ForegroundColor Cyan  
# Write-Host "Not sure if this is needed, or if we have to wait for the mailbox to sync back down to local AD." -ForegroundColor Cyan  
# Write-Host "This just seems to work" -ForegroundColor Cyan  
# Write-Host "------------------------------------------------------------------------------------------------"
# Start-Sleep -s 15
# Write-Host "----- 0:15"
# Start-Sleep -s 15
# Write-Host "----- 0:30"
# Start-Sleep -s 15
# Write-Host "----- 0:45"
# Start-Sleep -s 15
# Write-Host "----- 1:00"
# Start-Sleep -s 15
# Write-Host "----- 1:15"
# Start-Sleep -s 15
# Write-Host "----- 1:30"
# Start-Sleep -s 15
# Write-Host "----- 1:45"
# Start-Sleep -s 15
# Write-Host "----- 2:00"
# Start-Sleep -s 15
# Write-Host "----- 2:15"
# Start-Sleep -s 15
# Write-Host "----- 2:30"
# Start-Sleep -s 15
# Write-Host "----- 2:45"
# Start-Sleep -s 15
# Write-Host "----- 3:00"
# Start-Sleep -s 15
# Write-Host "----- 3:15"
# Start-Sleep -s 15
# Write-Host "----- 3:30"
# Start-Sleep -s 15
# Write-Host "----- 3:45"
# Start-Sleep -s 15
# Write-Host "----- 4:00"

# # Give E3 licence to user
# Connect-MSOLService -Credential $O365CREDS
# Get-ADUser $UserLowerCase | Set-MsolUser  -UsageLocation $Domain                   # Sets the location (Country) of the user
# Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:ENTERPRISEPACK"   # Gives E3 licence
