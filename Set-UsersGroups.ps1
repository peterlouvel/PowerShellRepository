<#
.SYNOPSIS
    Gets a previously saved users groups and adds the groups to another user
.DESCRIPTION
    Gets a previously saved users groups and adds the groups to another user
.EXAMPLE
    PS C:\> Set-UsersGroups -User "Existing User" -FromUser "From User" -UsersDomain "au"
.NOTES
    Domain can be
        AU or NZ
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$User
    ,[Parameter(Mandatory=$true)]
    [string]$FromUser
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

# Admin User who has admin ability over all domains to add a user into each group for each domain
if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential "edmi\$AdminAccount"
} 

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}

#
if ($UsersDomain -eq "au"){
    $DomainController = "AuBneDC11.au.edmi.local"
} elseif ($UsersDomain -eq "nz"){
    $DomainController = "NzBneDC5.nz.edmi.local"
} elseif ($UsersDomain -eq "uk"){
    $DomainController = "UkBneDC2.uk.edmi.local"
} elseif ($UsersDomain -eq "sg"){
    $DomainController = "SgBneDC1.sg.edmi.local"
} else {
    Write-Host
    Write-Host "Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}

$GroupsFromFile   = $FromUser -replace ' ','.'
if (Test-Path -Path ".\usersgroups\$GroupsFromFile.csv" ) {
    $Groups =  Get-Content -Path ".\usersgroups\$GroupsFromFile.csv"
} else {
    Write-Host "File doesn't exit for $GroupsFromFile.csv"
    exit
}
$SamAccount = $User -replace ' ','.'
try {
    $NewAccountObject  = Get-ADUser -Identity $SamAccount -Server $DomainController -Credential $Cred
} Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Host "User " -ForegroundColor Red -NoNewline
    Write-Host  $User -NoNewline
    Write-Host " does not exit" -ForegroundColor Red
} Catch {
    Throw $Error[0]
    Write-Host "Error"
} 
$counter = 0
foreach ($UserGroup in $Groups){ 
    $GroupName = ($UserGroup -split ",",2)[0]
    if ($UserGroup.Contains("DC=au")){
        Write-Host "AU  -- "$GroupName.Substring(3) -ForegroundColor Green
        $Server = "au.edmi.local"
    }elseif ($UserGroup.Contains("DC=nz")){
        Write-Host "NZ  -- "$GroupName.Substring(3) -ForegroundColor Green
        $Server = "nz.edmi.local"
    }elseif ($UserGroup.Contains("DC=sg")){
        Write-Host "SG  -- "$GroupName.Substring(3) -ForegroundColor Green
        $Server = "SG.edmi.local"
    }else{
        Write-Host "ROOT  -- "$GroupName.Substring(3) -ForegroundColor Green
        $Server = "edmi.local"
    }
    
    # Write-Host $UserGroup
    # write-host $NewAccountObject.DistinguishedName
    # write-host $Server
    try{
        $result = Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $EDMICREDS
        Write-Host "-- [Worked] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Yellow 
        Write-Host "----------------------------------------------------"
    }catch{
        Write-Host "-- Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $EDMICREDS" -ForegroundColor Yellow
        Write-Host "-- [ERROR] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Cyan
        Write-Host "   $($Error[0])" -ForegroundColor Red
        Write-Host "----------------------------------------------------"
    }
    $counter++
}