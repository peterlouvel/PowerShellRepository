<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Enable-O365Email -User "user.name" -Domain "au" -LicenceCode "E1"
    Creates the users mailbox on O365 and enables E3 licence 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz

        AccountSkuID	            Description
        BI_AZURE_P1	                Power BI (Business Intelligence) Reporting and Analytics
        CRMIUR	                    Customer Relationship Management Internal Use Rights
        DESKLESSPACK	            Office 365 (Plan K1)
        DESKLESSWOFFPACK	        Office 365 (Plan K2)
        DEVELOPERPACK	            Office 365 For Developers
        ECAL_SERVICES	            Enterprise Client Access Services
        EMS	                        Enterprise Mobility Suite
        ENTERPRISEPACK	            Enterprise Plan E3
        ENTERPRISEPACK_B_PILOT	    Office 365 (Enterprise Preview)
        ENTERPRISEPACK_FACULTY	    Office 365 (Plan A3) for Faculty
        ENTERPRISEPACK_STUDENT	    Office 365 (Plan A3) for Students
        ENTERPRISEPACKLRG	        Enterprise Plan E3
        ENTERPRISEWITHSCAL	        Enterprise Plan E4
        ENTERPRISEWITHSCAL_FACULTY	Office 365 (Plan A4) for Faculty
        ENTERPRISEWITHSCAL_STUDENT	Office 365 (Plan A4) for Students
        EXCHANGESTANDARD	        Office 365 Exchange Online Only
        INTUNE_A	                Windows Intune Plan A
        LITEPACK	                Office 365 (Plan P1)
        MCOMEETADV	                Public switched telephone network (PSTN) conferencing
        PLANNERSTANDALONE	        Planner Standalone
        POWER_BI_ADDON	            Office 365 Power BI Add-on
        POWER_BI_INDIVIDUAL_USE	    Power BI Individual User
        POWER_BI_PRO	            Power-BI Professional
        POWER_BI_STANDALONE	        Power BI Standalone
        POWER_BI_STANDARD	        Power-BI Standard
        PROJECTCLIENT	            Project Professional
        PROJECTESSENTIALS	        Project Lite
        PROJECTONLINE_PLAN_1	    Project Online
        PROJECTONLINE_PLAN_2	    Project Online (and Professional Version)
        RIGHTSMANAGEMENT_ADHOC	    Windows Azure Rights Management
        SHAREPOINTSTORAGE	        SharePoint storage
        STANDARD_B_PILOT	        Office 365 (Small Business Preview)
        STANDARDPACK	            Enterprise Plan E1
        STANDARDPACK_FACULTY	    Office 365 (Plan A1) for Faculty
        STANDARDPACK_STUDENT	    Office 365 (Plan A1) for Students
        STANDARDWOFFPACK	        Office 365 (Plan E2)
        STANDARDWOFFPACKPACK_FACULTY	Office 365 (Plan A2) for Faculty
        STANDARDWOFFPACKPACK_STUDENT	Office 365 (Plan A2) for Students
        VISIOCLIENT	                Visio Pro Online

        Get-MsolSubscription | Where-Object {($_.Status -ne "Suspended")}
#>



param(
    [Parameter(Mandatory=$true)]
    [string]$User
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain
    ,
    [Parameter(Mandatory=$false)]
    [string]$LicenceCode
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
    $O365CREDS = Get-Credential $Account
} 

# Install-Module -Name AzureAD
# Connect-AzureAD -AccountId $Email
# Get-AzureADUser -ObjectId


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
Write-Host "Waiting a couple minutes for O365 email account to be created before enabling licence." -ForegroundColor Cyan  
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
If ($LicenceCode -eq "E3") {
    Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:ENTERPRISEPACK"   # Gives E3 licence
}
If ($LicenceCode -eq "E1") {
    Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:STANDARDPACK"   # Gives E3 licence
}