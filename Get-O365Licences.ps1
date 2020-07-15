<#
.SYNOPSIS
    
.DESCRIPTION
    
.EXAMPLE
    PS C:\> Get-O365Licences
   
.INPUTS
    .
.OUTPUTS
    .
.NOTES
        E3
        ENTERPRISEPACK
        E1
        STANDARDPACK
        STREAM
        FLOW_FREE
        VISIO
        
        EDMI Pty Ltd, Scott Walker , 74430ce8-49b7-4f72-8b54-1c334958bf25
 
        New Subscription Id	                                                                Product Name	            Start Date	End Date
        4D4ECDEA-4CD4-4C10-9BF1-198C855B80C4	f8a1db68-be16-40ed-86d5-cb42ce701560    Power BI Pro	            30/09/2019	26/10/2020
        C1EBFD10-C1D0-4299-BB17-DFCCB4ED3176    c5928f49-12ba-48f7-ada3-0d743a3601d5    Visio Online Plan 2	        30/09/2019	26/10/2020
        1EC5CFAD-301F-4E1D-BE20-2C866C620368	18181a46-0d4e-45cd-891e-60aabd171b4e    Office 365 E1	            30/09/2019	26/10/2020
        0509C8EA-3871-4B6F-8DF8-5D5F8C79850B	6fd2c87f-b296-42f0-b197-1e91e994b900    Office 365 E3	            30/09/2019	26/10/2020
        59B7E94D-3C77-41A2-8E6C-6CAF894C83FD	4b9405b0-7788-4568-add1-99614e613b69    Exchange Online (Plan 1)	30/09/2019	26/10/2020
        
        Subscription Id	                        Subscription Name        Product Name
        6fd2c87f-b296-42f0-b197-1e91e994b900    E3                      Office 365 E3
        6fd2c87f-b296-42f0-b197-1e91e994b900    ENTERPRISEPACK          Office 365 E3
        18181a46-0d4e-45cd-891e-60aabd171b4e    E1                      Office 365 E1
        18181a46-0d4e-45cd-891e-60aabd171b4e    STANDARDPACK            Office 365 E1
        1f2f344a-700d-42c9-9427-5cea1d5d7ba6    STREAM
        f30db892-07e9-47e9-837c-80727f46fd3d    FLOW_FREE
        c5928f49-12ba-48f7-ada3-0d743a3601d5    VISIO                   Visio Online (Plan 2)
        c5928f49-12ba-48f7-ada3-0d743a3601d5    VISIOCLIENT             Visio Online (Plan 2)
        4b9405b0-7788-4568-add1-99614e613b69    EXCHANGE_ONLINE         Exchange Online (Plan 1)
        f8a1db68-be16-40ed-86d5-cb42ce701560    POWER_BI_PRO            Power BI Pro
        a403ebcc-fae0-4ca2-8c8c-7a907fd6c235    POWER_BI_STANDARD
        dcb1a3ae-b33f-4487-846a-a640262fadf4    POWERAPPS_VIRAL
        29a2f828-8f39-4837-b8ff-c957e86abe3c    TEAMS_COMMERCIAL_TRIAL
        d42c793f-6c78-4f43-92ca-e8f6a02b035f    MCOSTANDARD
        74fbf1bb-47c6-4796-9623-77dc7371723b    MS_TEAMS_IW
        726a0894-2c77-4d65-99da-9775ef05aad1    MICROSOFT_BUSINESS_CENTER
        6470687e-a428-4b7a-bef2-8a291ad947c9    WINDOWS_STORE
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$licenceName
)


$ShowText = "
 E3
 E1
 STREAM
 FLOW_FREE
 VISIO
 EXCHANGE_ONLINE
 POWER_BI_PRO
 POWER_BI_STANDARD
 POWERAPPS_VIRAL
 MCOSTANDARD
 MS_TEAMS_IW
 MICROSOFT_BUSINESS_CENTER
 WINDOWS_STORE
"

if ( -not $licenceName){
    Write-Host $ShowText
    [String] $licenceName=$(Read-Host -prompt "Enter the Licence")
}

$UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname

# Install-Module -Name AzureAD -Scope CurrentUser
$temp = Connect-AzureAD -AccountId $UPNAccount 

$subscription = @{}
$subscription.add("E3"                        ,"6fd2c87f-b296-42f0-b197-1e91e994b900")
$subscription.add("ENTERPRISEPACK"            ,"6fd2c87f-b296-42f0-b197-1e91e994b900")
$subscription.add("E1"                        ,"18181a46-0d4e-45cd-891e-60aabd171b4e")
$subscription.add("STANDARDPACK"              ,"18181a46-0d4e-45cd-891e-60aabd171b4e")
$subscription.add("STREAM"                    ,"1f2f344a-700d-42c9-9427-5cea1d5d7ba6")
$subscription.add("FLOW_FREE"                 ,"f30db892-07e9-47e9-837c-80727f46fd3d")
$subscription.add("VISIO"                     ,"c5928f49-12ba-48f7-ada3-0d743a3601d5")
$subscription.add("VISIOCLIENT"               ,"c5928f49-12ba-48f7-ada3-0d743a3601d5")
$subscription.add("EXCHANGE_ONLINE"           ,"4b9405b0-7788-4568-add1-99614e613b69")
$subscription.add("EXCHANGESTANDARD"          ,"4b9405b0-7788-4568-add1-99614e613b69")
$subscription.add("POWER_BI_PRO"              ,"f8a1db68-be16-40ed-86d5-cb42ce701560")
$subscription.add("POWER_BI_STANDARD"         ,"a403ebcc-fae0-4ca2-8c8c-7a907fd6c235")
$subscription.add("POWERAPPS_VIRAL"           ,"dcb1a3ae-b33f-4487-846a-a640262fadf4")
$subscription.add("TEAMS_COMMERCIAL_TRIAL"    ,"29a2f828-8f39-4837-b8ff-c957e86abe3c")
$subscription.add("MCOSTANDARD"               ,"d42c793f-6c78-4f43-92ca-e8f6a02b035f")
$subscription.add("MS_TEAMS_IW"               ,"74fbf1bb-47c6-4796-9623-77dc7371723b")
$subscription.add("MICROSOFT_BUSINESS_CENTER" ,"726a0894-2c77-4d65-99da-9775ef05aad1")
$subscription.add("WINDOWS_STORE"             ,"6470687e-a428-4b7a-bef2-8a291ad947c9")

Write-Host $licenceName " = " $subscription[$licenceName]
Write-Host "----------------------------------------------"
$Users = Get-AzureADUser -All $true | Where-Object {($_.AssignedLicenses).SkuID -eq $subscription[$licenceName]} | Sort-Object Country, City, DisplayName

foreach ($User in $Users) {
    Write-Host $User.City "`t" $User.DisplayName 
}
