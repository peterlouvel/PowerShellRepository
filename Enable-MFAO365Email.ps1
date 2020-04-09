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
    https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference
      AccountSkuID	            Description
        BI_AZURE_P1	                Power BI (Business Intelligence) Reporting and Analytics
        CRMIUR	                    Customer Relationship Management Internal Use Rights
        DESKLESSPACK	            Office 365 (Plan K1)
        DESKLESSWOFFPACK	        Office 365 (Plan K2)
        DEVELOPERPACK	            Office 365 For Developers
        ECAL_SERVICES	            Enterprise Client Access Services
        EMS	                        Enterprise Mobility Suite
        ENTERPRISEPACK	            Enterprise Plan E3      6fd2c87f-b296-42f0-b197-1e91e994b900
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
        STANDARDPACK	            Enterprise Plan E1      18181a46-0d4e-45cd-891e-60aabd171b4e
        STANDARDPACK_FACULTY	    Office 365 (Plan A1) for Faculty
        STANDARDPACK_STUDENT	    Office 365 (Plan A1) for Students
        STANDARDWOFFPACK	        Office 365 (Plan E2)
        STANDARDWOFFPACKPACK_FACULTY	Office 365 (Plan A2) for Faculty
        STANDARDWOFFPACKPACK_STUDENT	Office 365 (Plan A2) for Students
        VISIOCLIENT	                Visio Pro Online

        Get-MsolSubscription | Where-Object {($_.Status -ne "Suspended")}
#>

#Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

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

if ($stUserDomain -eq "au"){
    $EndAdmin = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $EndAdmin = "@edmi.co.nz"
} else {
    Write-Host "Your local account needs to be either AU or NZ" -ForegroundColor Red  
    exit
}

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    if ($null -eq $Cred){
        $AdminAccount = $stUserAccount + "_"
        $AdminAccount1 = "au\"+$AdminAccount
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    if ($null -eq $Cred){
        $AdminAccount = $stUserAccount + "_"
        $AdminAccount1 = "nz\"+$AdminAccount
        $Cred = Get-Credential $AdminAccount1
    }
} else {
    Write-Host "Domain should be AU or NZ" -ForegroundColor Red  
    exit
}

$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase + $End
# Write-Host "User eMail:  $Email"
Write-Host
Write-Host "Setup your Credentials for accessing the Office 365 systems - " -ForegroundColor Green  -NoNewline
$Account = $stUserAccount + $EndAdmin
Write-Host $Account 
$temp = Install-Module -Name AzureAD
$temp = Connect-AzureAD -AccountId $Account

try {
    $temp = Get-AzureADUser -ObjectId $Email #-erroraction 'silentlycontinue'
}
catch {
    Write-Host "User" -ForegroundColor Red  -NoNewline
    Write-Host " $User " -ForegroundColor Cyan  -NoNewline
    Write-Host "doesn't exist on Office 365 yet - wait till the user is on O365" -ForegroundColor Red  
    exit
}

Write-Host "User " -ForegroundColor Green  -NoNewline
Write-Host " $User " -ForegroundColor Cyan -NoNewline 
Write-Host " exits. Creating Mailbox on O365" -ForegroundColor Green 
Write-Host
Write-Host "Connecting to the Local Exchange Server" -ForegroundColor Green  
# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
$temp = Import-PSSession $Session1 3>$null
$UserO365email = $UserLowerCase + "@edmi.mail.onmicrosoft.com"
Write-Host "Setting up remote mailbox for user " -ForegroundColor Green -NoNewline
Write-Host " $UserLowerCase " -ForegroundColor Cyan  
Write-Host

$temp = Enable-RemoteMailbox -Identity $UserLowerCase  -DomainController $DomainController -RemoteRoutingAddress $UserO365email -erroraction 'silentlycontinue'

Exit-PSSession
Remove-PSSession $Session1

Write-Host "------------------------------------------------------------------------------------------------"
Write-Host "Waiting a couple minutes for O365 email account to be created before enabling licence." -ForegroundColor Cyan  
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

# Give licence to user

Set-AzureADUser -ObjectId $Email -UsageLocation $Domain
#Get-ADUser $UserLowerCase -Credential $Cred -Server $DomainController | Set-MsolUser  -UsageLocation $Domain                   # Sets the location (Country) of the user
# Set-AzureADUser -ObjectId $UserLowerCase.UserPrincipleName -City " "
If ($LicenceCode -eq "E3") {
    $planName="ENTERPRISEPACK"
}
If ($LicenceCode -eq "E1") {
    $planName="STANDARDPACK"
}
Write-Host "Give licence " -ForegroundColor Green -NoNewline
Write-Host " $planName " -ForegroundColor Cyan -NoNewline
Write-Host " to user " -ForegroundColor Green -NoNewline
Write-Host " $User" -ForegroundColor Cyan

$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
Set-AzureADUserLicense -ObjectId $Email -AssignedLicenses $LicensesToAssign
Write-Host
