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
} elseif ($stUserDomain -eq "nz"){
    $End = "@edmi.co.nz"
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



