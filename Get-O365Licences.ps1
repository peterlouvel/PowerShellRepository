<#
.SYNOPSIS
    
.DESCRIPTION
    
.EXAMPLE
    PS C:\> MoveLicence
   
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz

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
    [Parameter(Mandatory=$true)]
    [string]$licenceName
)

Install-Module AzureAD -Force -Scope CurrentUser

[String] ${stUserDomain}, [String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
# Write-Host $stUserDomain
# Write-Host $stUserAccount

# Setup correct ending for UPN
if ($stUserDomain -eq "au"){
    $End = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $End = "@edmi.co.nz"
} else {
    Write-Host "Run this command with your AU or NZ Domain credentials that can access Office 365"
    exit
}

#if $O365CREDS not setup before script run, setup now
if ($null -eq $O365CREDS){
    $Account = $stUserAccount + $End
    # Write-Host $Account
    $O365CREDS   = Get-Credential $Account
} 

Install-Module -Name AzureAD -Scope CurrentUser
Connect-AzureAD -Credential $O365CREDS
Connect-MsolService -Credential $O365CREDS

# $licensePlanList = Get-AzureADSubscribedSku
# # Write-Host $licensePlanList
# $AccountSkuIdNumbers = Get-MsolAccountSku
# # Write-Host AccountSkuIdNumbers

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


$Users = Get-MsolUser -All | Where-Object -Property isLicensed | select -Property *
Write-Host $licenceName " = " $subscription[$licenceName] 

foreach ($User in $Users) {
    # Write-Host "------------------------------"
    $userUPN = $User.UserprincipalName
    $userList = Get-AzureADUser -ObjectID $userUPN | Select -ExpandProperty AssignedLicenses | Select SkuID 
    # Write-host "UserList " $userList
    $userList | ForEach { 
        $sku = $_.SkuId 
        if ( $sku -eq $subscription[$licenceName]) {
            Write-Host $User.Country "`t" $User.City "`t" $userUPN 
            # Write-Host "++ " $_.SkuPartNumber 
        }
    }
}

<#

$userUPN = "peter.louvel@edmi.com.au"

$licenseFrom = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licensesFrom = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$licenseTo = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licensesTo = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

#Adds Current licence
$licenseFrom.SkuId = "6fd2c87f-b296-42f0-b197-1e91e994b900"
$licensesFrom.AddLicenses = $licenseFrom
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesFrom

#Removes that licence
$licensesFrom.AddLicenses = @()
$licensesFrom.RemoveLicenses =  $licenseFrom.SkuId
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesFrom

# Assign new licence
$licenseTo.SkuId = "796b6b5f-613c-4e24-a17c-eba730d49c02"
$licensesTo.AddLicenses = $LicenseTo
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesTo

#>

<#      in vscode 
    ##    
        $Mycert = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0]
        $currentFile = $psEditor.GetEditorContext().CurrentFile.Path
        Set-AuthenticodeSignature -Certificate $Mycert -FilePath $currentFile
    
    ##  
        Set-AuthenticodeSignature -FilePath ${activeFile} -Certificate @(Get-ChildItem cert:\\CurrentUser\\My -codesign)[0]
        Set-AuthenticodeSignature -FilePath $psEditor.GetEditorContext().CurrentFile.Path -Certificate @(Get-ChildItem cert:\\CurrentUser\\My -codesign)[0]
#>

