<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Create-O365Email -User "user.name" -Domain "au" -LicenceCode "E1"
    Creates the users mailbox on O365 and enables Office 365 licence 
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
    [string]$UserName
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
    ,[Parameter(Mandatory=$true)]
    [string]$LicenceCode
)

# This will get the API $token for the bonus.ly website
Get-Content ".\variables.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain = $stYourDomain
}
$ex1 = $true
$LocationISO = $UsersDomain
if ($UsersDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $FQD = "au.edmi.local"
    $Location = "Australia"
    $LocationBonusly = "Australia/Queensland"
    $ex1 = $false
}
if ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $FQD = "nz.edmi.local"
    $Location = "New Zealand"
    $LocationBonusly = "Pacific/Auckland"
    $ex1 = $false
 }

if ($ex1) {
    Write-Host
    Write-Host "Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}
if ($null -eq $UPNAccount){ $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname } # $UPNAccount

#using your Root EDMI account so that you can get access to all the domains (if it's setup that way)
if ($null -eq $EDMICREDS){ $EDMICREDS = Get-Credential "edmi\$AdminAccount" } 

$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'
$UserEmail      = $UserAccount.ToLower() + $End
# $UserEmail

Write-Host
Write-Host "Setup your Credentials for accessing the Office 365 systems - " -ForegroundColor Green  -NoNewline
Write-Host $UPNAccount 

# $temp = Install-Module -Name AzureAD
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
Write-Host " exits. Creating Remote Mailbox on Exchange3 with your EDMI Admin account." -ForegroundColor Green 
Write-Host "Which will create the O365 email account" -ForegroundColor Green 
Write-Host
# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch3.edmi.local/powershell -Credential $EDMICREDS
$temp = Import-PSSession $Session1 3>$null
$UserO365email = $UserAccount + "@edmi.mail.onmicrosoft.com"
Write-Host "Setting up remote mailbox for user " -ForegroundColor Green -NoNewline
Write-Host " $UserEmail " -ForegroundColor Cyan  
Write-Host
try {
    $temp = Enable-RemoteMailbox -Identity $UserAccount  -DomainController $DomainController -RemoteRoutingAddress $UserO365email #-erroraction 'silentlycontinue'
}
catch {
    Write-Host "user account might already exist " -ForegroundColor Green
}


$temp = Exit-PSSession
$temp = Remove-PSSession $Session1
 
# Write-Host "------------------------------------------------------------------------------------------------"
# Write-Host "  Log into https://admin.microsoft.com/AdminPortal/Home#/users and give a licence to the user"
# Write-Host "------------------------------------------------------------------------------------------------"

 Write-Host "Waiting a couple minutes for O365 email account to be created before enabling licence." -ForegroundColor Cyan  
    Write-Host "------------------------------------------------------------------------------------------------"
    Write-Host "----- 0:00"
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
Write-Host "Setting user location to $Location   $LocationISO"  -ForegroundColor Green  
$Temp = Set-AzureADUser -ObjectId $UserEmail -UsageLocation $LocationISO 

If ($LicenceCode -eq "E3") {
    $planName = "ENTERPRISEPACK"
}
If ($LicenceCode -eq "E1") {
    $planName = "STANDARDPACK"
}
If ($LicenceCode -eq "Ex") {
    $planName = "EXCHANGESTANDARD"
}

Write-Host "Give licence " -ForegroundColor Green -NoNewline
Write-Host " $planName " -ForegroundColor Cyan -NoNewline
Write-Host " to user " -ForegroundColor Green -NoNewline
Write-Host " $User" -ForegroundColor Cyan

$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
$Temp = Set-AzureADUserLicense -ObjectId $UserEmail -AssignedLicenses $LicensesToAssign
Write-Host

Write-Host "Setup User to have access to Microsoft Teams  ANZ EDMI"
write-host " -- select the account from the popup window --"
$Temp = Import-Module MicrosoftTeams
# Install-Module MicrosoftTeams
$Temp = Connect-MicrosoftTeams 
$Temp = Get-Team -DisplayName "ANZ EDMI" | Add-TeamUser  -User "$UserEmail"

Write-Host "Users email address is " -NoNewline -ForegroundColor Green
write-host $UserEmail
Write-Host

# $LocationBonusly = "Pacific/Auckland"
# $LocationISO = "nz"
# $username = "test1.test"
# $UserEmail = "$username@edmi.com.au"



$Header = @{"authorization" = "Bearer $token"}
$Name = $UserEmail.split(".")

# Write-Host "$UserEmail"
# Write-Host  "$Name[0]"
# Write-Host  "$Name[1]"
# Write-Host  "$LocationBonusly"
# Write-Host  "$LocationISO"

$Body = @{
    email       = $UserEmail
    first_name  = $Name[0]
    last_name   = $Name[1]
    time_zone   = $LocationBonusly
    country     = $LocationISO
}

$Parameters = @{
    Method 		= "POST"
    Uri 		= "https://bonus.ly/api/v1/users"
	Headers     = $Header
    ContentType = "application/json"
	Body 		= ($Body | ConvertTo-Json) 
}

# Write-Host "Creating bonusly account" -ForegroundColor Cyan  
# Start-Sleep -s 5

$CreatedUserDetails = Invoke-RestMethod @Parameters
Write-Host "User Created on bonus.ly " -NoNewline -ForegroundColor Green
write-host $CreatedUserDetails.result.username

