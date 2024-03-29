<#
.SYNOPSIS
    Create a new User and copy other users groups and info
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-UsersGroup -User "existing.user" -UsersDomain "au"
    
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
    [string]$User
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
    $DomainController = "au.edmi.local"
    $FQD = "au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    $Location = "Australia"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1} 
} elseif ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "nz.edmi.local"
    $FQD = "nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    $Location = "New Zealand"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "uk"){
    $End = "@edmi-meters.com"
    $DomainController = "uk.edmi.local"
    $FQD = "uk.edmi.local"
    $AdminAccount1 = "uk\"+$AdminAccount
    $Location = "United Kingdom"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "sg"){
    $End = "@edmi-meters.com"
    $DomainController = "sg.edmi.local"
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

if (Test-Path -Path ".\usersgroups\$User.csv" -PathType Leaf) {
    Remove-Item -Path ".\usersgroups\$User.csv"
}

# Get the users AD Info
$UserObject = Get-ADUser -Identity $User -Server $DomainController -Properties * | Select-Object -Property DistinguishedName,Department,Path,Office,StreetAddress,City,State,PostalCode,Country,POBox,Company,HomePage,Manager,memberof

$UserOU             = ($UserObject.DistinguishedName -split ",",2)[1]
$Department         = $UserObject.Department
$Office             = $UserObject.Office
$City               = $UserObject.City
$PostalCode         = $UserObject.PostalCode
$POBox              = $UserObject.POBox
$HomePage           = $UserObject.HomePage
$Address            = $UserObject.StreetAddress
$State              = $UserObject.State
$Country            = $UserObject.Country
$Company            = $UserObject.Company
$Manager            = $UserObject.Manager

$params = @{  
    Department          = "$Department" 
    Path                = "$UserOU"
    Office              = "$Office"
    StreetAddress       = "$Address"
    City                = "$City"
    State               = "$State"
    PostalCode          = "$PostalCode"
    Country             = "$Country"
    POBox               = "$POBox"
    Company             = "$Company"
    HomePage            = "$HomePage"
    Manager             = "$Manager"
}

# Save the users AD Info
@"
@{
$(
  ($params.GetEnumerator() |
    ForEach-Object { 
      "  {0}={1}" -f $_.Name, (
        $_.Value.ForEach({ 
          (("'{0}'" -f ($_ -replace "'", "''")), $_)[$_.GetType().IsPrimitive] 
         }) -join ','
      )
    }
  ) -join "`n"
)
}
"@ > ".\usersgroups\$User.txt"

# Save the groups that the user is in
$UserObject | Select-Object -ExpandProperty memberof | Out-File -FilePath ".\usersgroups\$User.csv"
