<#
.SYNOPSIS
    Create a new User and copy other users groups and info
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-UsersGroup -FromUser "existing.user" -UsersDomain "au"
    Creates user "new.user and copies some info from "existing.user" 
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
    [string]$FromUser
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}

if ($UsersDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $FQD = "au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    $Location = "Australia"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1} 
} elseif ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $FQD = "nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    $Location = "New Zealand"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "uk"){
    $End = "@edmi-meters.com"
    $DomainController = "UkBneDC2.uk.edmi.local"
    $FQD = "uk.edmi.local"
    $AdminAccount1 = "uk\"+$AdminAccount
    $Location = "United Kingdom"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "sg"){
    $End = "@edmi-meters.com"
    $DomainController = "SgBneDC1.sg.edmi.local"
    $FQD = "sg.edmi.local"
    $AdminAccount1 = "sg\"+$AdminAccount
    $Location = "Singapore"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} else {
    Write-Host
    Write-Host "Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}

# $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname
if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential "edmi\$AdminAccount"
} 


$Params             = @("Department", 
                "Office", 
                "physicalDeliveryOfficeName", 
                "City", 
                "wWWHomePage", 
                "PostalCode", 
                "POBox", 
                "postOfficeBox", 
                "DistinguishedName",
                "StreetAddress",
                "State",
                "Country",
                "Company",
                "Manager",
                "MemberOf"
                # ,"co"
                    )

$CopyUserObject = Get-ADUser -Identity $FromUser -Properties $Params -Server $DomainController


# Write-Host "- ready to copy groups -"

Remove-Item -Path "c:\temp\$FromUser.csv"

$CopyUserObject | Select-Object $_.MemberOf | Export-CSV -Path "c:\temp\$FromUser.csv"
