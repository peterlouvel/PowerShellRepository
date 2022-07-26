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

        VISIOCLIENT                 74430ce8-49b7-4f72-8b54-1c334958bf25_c5928f49-12ba-48f7-ada3-0d743a3601d5                                         
        STREAM                      74430ce8-49b7-4f72-8b54-1c334958bf25_1f2f344a-700d-42c9-9427-5cea1d5d7ba6                                              
        POWER_BI_PRO                74430ce8-49b7-4f72-8b54-1c334958bf25_f8a1db68-be16-40ed-86d5-cb42ce701560 
        WINDOWS_STORE               74430ce8-49b7-4f72-8b54-1c334958bf25_6470687e-a428-4b7a-bef2-8a291ad947c9 
        ENTERPRISEPACK              74430ce8-49b7-4f72-8b54-1c334958bf25_6fd2c87f-b296-42f0-b197-1e91e994b900                                      
        FLOW_FREE                   74430ce8-49b7-4f72-8b54-1c334958bf25_f30db892-07e9-47e9-837c-80727f46fd3d                                           
        MICROSOFT_BUSINESS_CENTER   74430ce8-49b7-4f72-8b54-1c334958bf25_726a0894-2c77-4d65-99da-9775ef05aad1 
        PROJECT_P1                  74430ce8-49b7-4f72-8b54-1c334958bf25_beb6439c-caad-48d3-bf46-0c82871e12be 
        POWERAPPS_VIRAL             74430ce8-49b7-4f72-8b54-1c334958bf25_dcb1a3ae-b33f-4487-846a-a640262fadf4                                     
        EXCHANGESTANDARD            74430ce8-49b7-4f72-8b54-1c334958bf25_4b9405b0-7788-4568-add1-99614e613b69                                    
        POWER_BI_STANDARD           74430ce8-49b7-4f72-8b54-1c334958bf25_a403ebcc-fae0-4ca2-8c8c-7a907fd6c235                                   
        TEAMS_EXPLORATORY           74430ce8-49b7-4f72-8b54-1c334958bf25_710779e8-3d4a-4c88-adb9-386c958d1fdf                                   
        PROJECTPROFESSIONAL         74430ce8-49b7-4f72-8b54-1c334958bf25_53818b1b-4a27-454b-8896-0dba576410e6                                 
        Microsoft_Teams_Audio_Conferencing_select_dial_out  74430ce8-49b7-4f72-8b54-1c334958bf25_1c27243e-fb4d-42b1-ae8c-fe25c9616588 
        POWERAPPS_DEV               74430ce8-49b7-4f72-8b54-1c334958bf25_5b631642-bd26-49fe-bd20-1daaa972ef80 
        STANDARDPACK                74430ce8-49b7-4f72-8b54-1c334958bf25_18181a46-0d4e-45cd-891e-60aabd171b4e                                        

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
    $Location = "Australia"
    $ex1 = $false
}
if ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $Location = "New Zealand"
    $ex1 = $false
 }
 if ($UsersDomain -eq "sg"){
    $End = "@edmi-meters.com"
    $DomainController = "SgBneDC1.sg.edmi.local"
    # $DomainController = "SgSinDC11.sg.edmi.local"
    $Location = "Singapore"
    $ex1 = $false
 }
if ($ex1) {
    Write-Host
    Write-Host "Domain should be AU, NZ, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}
if ($null -eq $UPNAccount){ $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname } # $UPNAccount

#using your Root EDMI account so that you can get access to all the domains (if it's setup that way)
if ($null -eq $EDMICREDS){ $EDMICREDS = Get-Credential "edmi\$AdminAccount" } 

# Write-Host "UsersName before ------  $UserName"
$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
# Write-Host "UsersName after ------  $UserName"
$UserAccount    = $UserName -replace ' ','.'
# Write-Host "UsersAccopunt ------  $UserAccount"
$UserEmail      = $UserAccount.ToLower() + $End
Write-Host "Users eMail ------  $UserEmail"

Write-Host
Write-Host "Setup your Credentials for accessing the Office 365 systems - " -ForegroundColor Green  -NoNewline
Write-Host $UPNAccount 

# $temp = Install-Module -Name AzureAD
$temp = Connect-AzureAD -AccountId $UPNAccount

try {
    $temp = Get-AzureADUser -ObjectId $UserEmail #-erroraction 'silentlycontinue'
}
catch {
    Write-Host "Account" -ForegroundColor Red  -NoNewline
    Write-Host " $UserName " -ForegroundColor Cyan  -NoNewline
    Write-Host "doesn't exist on Office 365 - wait till the user is on O365" -ForegroundColor Red  
    exit
}

Write-Host "------------------------------------------------------------------------------------------------"
Write-Host "  Log into https://admin.microsoft.com/AdminPortal/Home#/users and give a licence to the user"
Write-Host "------------------------------------------------------------------------------------------------"

# Give licence to user
Write-Host "Setting user location to $Location   $LocationISO"  -ForegroundColor Green  
$Temp = Set-AzureADUser -ObjectId $UserEmail -UsageLocation $LocationISO 
$planName = "Microsoft_Teams_Audio_Conferencing_select_dial_out"

Write-Host "Give licence " -ForegroundColor Green -NoNewline
Write-Host " $planName " -ForegroundColor Cyan -NoNewline
Write-Host " to user " -ForegroundColor Green -NoNewline
Write-Host " $User" -ForegroundColor Cyan

$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
$Temp = Set-AzureADUserLicense -ObjectId $UserEmail -AssignedLicenses $LicensesToAssign
Write-Host " "

Write-Host "Setup User to have access to Microsoft Teams  ANZ EDMI"
write-host " -- select the account from the popup window --"
$Temp = Import-Module MicrosoftTeams
$Temp = Install-Module MicrosoftTeams
$Temp = Connect-MicrosoftTeams 
$Temp = Get-Team -DisplayName "ANZ EDMI" | Add-TeamUser  -User "$UserEmail"

Write-Host "Users email address is " -NoNewline -ForegroundColor Green
write-host $UserEmail
Write-Host

