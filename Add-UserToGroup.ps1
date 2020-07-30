<#
.SYNOPSIS
    Create a new User and copy other users groups and info
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Create-NewUser -UserName "FirstName LastName" -FromUser "existing.user" -Title "New Users Job Title" -UsersDomain "au"
    Creates user "new.user and copies some info from "existing.user" 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz
        sg
        uk
        edmi

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
    ,[Parameter(Mandatory=$true)]
    [string]$UsersDomain 
    ,[Parameter(Mandatory=$true)]
    [string]$GroupName
    ,[Parameter(Mandatory=$true)]
    [string]$GroupsDomain
)


[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($GroupsDomain -eq "au"){
    $AdminAccount1 = "au\"+$AdminAccount
    if ($null -eq $CredAU){
        $Cred = Get-Credential $AdminAccount1} 
    $Cred = $CredAU
} elseif ($GroupsDomain -eq "nz"){
    $AdminAccount1 = "nz\"+$AdminAccount
    if ($null -eq $CredNZ){
        $Cred = Get-Credential $AdminAccount1}
    $Cred = $CredNZ
} elseif ($GroupsDomain -eq "uk"){
    $End = "@edmi-meters.com"
    $AdminAccount1 = "uk\"+$AdminAccount
    if ($null -eq $CredUK){
        $Cred = Get-Credential $AdminAccount1} 
    $Cred = $CredUK
} elseif ($GroupsDomain -eq "sg"){
    $AdminAccount1 = "sg\"+$AdminAccount
    if ($null -eq $CredSG){
        $Cred = Get-Credential $AdminAccount1} 
    $Cred = $CredSG
} elseif ($GroupsDomain -eq "edmi"){
    $AdminAccount1 = "edmi\"+$AdminAccount
    if ($null -eq $CredEDMI){
        $Cred = Get-Credential $AdminAccount1} 
    $Cred = $CredEDMI
} else {
    Write-Host
    Write-Host "Group Domain should be AU, NZ, UK, SG, EDMI" -ForegroundColor Red 
    exit
}

$Staff = Get-ADUser -Identity "$UserName" -Server "$UsersDomain.edmi.local"  

$GroupInfo = Get-ADGroup -Identity "$GroupName" -Server $GroupsDomain
Set-ADObject -Identity $GroupInfo -Add @{"member"=$Staff.DistinguishedName} -Server $GroupsDomain -Credential $Cred