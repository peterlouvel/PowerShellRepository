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
#>

[String] ${stUserDomain}, [String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")

# Write-Host $stUserDomain
# Write-Host $stUserAccount

# Setup correct ending for UPN
if ($stUserDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $Server = "au.edmi.local"
} elseif ($stUserDomain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $Server = "nz.edmi.local"
} else {
    Write-Host "Domain should be AU or NZ"
    exit
}

# $Account = $stUserAccount + $End

#if $O365CREDS not setup before script run, setup now
if ($null -eq $O365CREDS){
    $O365CREDS   = Get-Credential $Account
} 
# Write-Host $Account

Install-Module -Name AzureAD
Connect-AzureAD -Credential $O365CREDS
Connect-MsolService -Credential $O365CREDS

$licensePlanList = Get-AzureADSubscribedSku
# Write-Host $licensePlanList

$Users = Get-MsolUser -All | Where-Object -Property isLicensed
foreach ($User in $Users){
    Write-Host "------------------------------"
    $userUPN=$User.UserprincipalName
    Write-Host $userUPN

    $userList = Get-AzureADUser -ObjectID $userUPN | Select -ExpandProperty AssignedLicenses | Select SkuID 
    Write-host $userList
    $userList | ForEach { $sku=$_.SkuId ; $licensePlanList | ForEach { If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) { Write-Host $_.SkuPartNumber } } }
}

<#

EDMI Pty Ltd, Scott Walker , 74430ce8-49b7-4f72-8b54-1c334958bf25
 
Subscription Id	Product Name	Start Date	End Date
4D4ECDEA-4CD4-4C10-9BF1-198C855B80C4	Power BI Pro	30/09/2019	26/10/2020
C1EBFD10-C1D0-4299-BB17-DFCCB4ED3176	Visio Online Plan 2	30/09/2019	26/10/2020
1EC5CFAD-301F-4E1D-BE20-2C866C620368	Office 365 E1	30/09/2019	26/10/2020
0509C8EA-3871-4B6F-8DF8-5D5F8C79850B	Office 365 E3	30/09/2019	26/10/2020
59B7E94D-3C77-41A2-8E6C-6CAF894C83FD	Exchange Online (Plan 1)	30/09/2019	26/10/2020
 

#>#>

