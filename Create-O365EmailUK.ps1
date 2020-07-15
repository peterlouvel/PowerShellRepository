<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Create-O365Email -UserName "user.name" 

    Creates the users mailbox on O365
.INPUTS
    -UserName
.OUTPUTS
    .
.NOTES

#>

#Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
)

# .".\IncludePWL.ps1"
[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

Write-Host "type in your Admin account password"
$UsersDomain = "uk"
$End = "@edmi-meters.com"
# $DomainController = "UkRdgDC1.uk.edmi.local"
$DomainController = "UkBneDC2.uk.edmi.local"
$Location = "United Kingdom"
$AdminAccount1 = "uk\"+$AdminAccount
if ($null -eq $CredUK){$CredUK = Get-Credential $AdminAccount1} 
$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'
$UserEmail      = $UserAccount.ToLower() + $End
$UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname

Write-Host
Write-Host "Setup your Credentials for accessing the Azure AD and Office 365 systems - " -ForegroundColor Green  -NoNewline
Write-Host $UPNAccount 

#This is used to test if the user account is synced to Office 365
$temp = Install-Module -Name AzureAD 
$temp = Connect-AzureAD -AccountId $UPNAccount

try {
    $temp = Get-AzureADUser -ObjectId $UserEmail #-erroraction 'silentlycontinue'
}
catch {
    Write-Host "User" -ForegroundColor Red  -NoNewline
    Write-Host " $UserName " -ForegroundColor Cyan  -NoNewline
    Write-Host "doesn't exist on Office 365 yet - wait till the user is on O365" -ForegroundColor Red  
    exit
}

Write-Host "User " -ForegroundColor Green  -NoNewline
Write-Host " $UserName " -ForegroundColor Cyan -NoNewline 
Write-Host " exits. Creating Mailbox on O365" -ForegroundColor Green 
Write-Host
Write-Host "Connecting to the Local Exchange Server" -ForegroundColor Green  
# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch3.edmi.local/powershell -Credential $CredUK
$temp = Import-PSSession $Session1 3>$null
$UserO365email = $UserAccount + "@edmi.mail.onmicrosoft.com"
Write-Host "Setting up remote mailbox for user " -ForegroundColor Green -NoNewline
Write-Host " $UserO365email " -ForegroundColor Cyan  
Write-Host

# Finally create the email account and setup it up to be on Office365 by using the remote mailbox command
Enable-RemoteMailbox -Identity $UserAccount  -DomainController $DomainController -RemoteRoutingAddress $UserO365email 

Exit-PSSession
Remove-PSSession $Session1
 
 Write-Host "------------------------------------------------------------------------------------------------"
 Write-Host "Wait a couple minutes for O365 email account to be created before enabling any licences." -ForegroundColor Cyan  
 Write-Host "------------------------------------------------------------------------------------------------"
 