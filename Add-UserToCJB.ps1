<#
.SYNOPSIS
    Add a User to a Confluence, Jira & bitbucket
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Add-UserToCJB -UserName "bob.hope" -UsersDomain "au" 
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
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($null -eq $Cred){
        $Cred = Get-Credential "edmi\$AdminAccount"
}

#  FQDN is not used - check is just to see if a domain was put in correctly
if ($UsersDomain -eq "au"){
    $UsersDomainFQN = "au.edmi.local"
} elseif ($UsersDomain -eq "nz"){
    $UsersDomainFQN = "nz.edmi.local"
} elseif ($UsersDomain -eq "uk"){
    $UsersDomainFQN = "uk.edmi.local"
} elseif ($UsersDomain -eq "sg"){
    $UsersDomainFQN = "sg.edmi.local"
} else {
    Write-Host
    Write-Host "User Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    exit
}

$GroupsDomain = "edmi"
$GroupsDomainFQN = "edmi.local"

# Write-Host "$UserName | $UsersDomain = $UsersDomainFQN | $GroupsDomain = $GroupsDomainFQN    "
$Staff = Get-ADUser -Identity "$UserName" -Server "$UsersDomainFQN"  
# Write-Host $Staff

$GroupName = "Role EDMI User NZ Confluence Instance Colab"
$GroupInfo = Get-ADGroup -Identity "$GroupName" -Server $GroupsDomain
Set-ADObject -Identity $GroupInfo -Add @{"member"=$Staff.DistinguishedName} -Server $GroupsDomain -Credential $Cred

$GroupName = "Role EDMI Team Jira Australasia"
$GroupInfo = Get-ADGroup -Identity "$GroupName" -Server $GroupsDomain
Set-ADObject -Identity $GroupInfo -Add @{"member"=$Staff.DistinguishedName} -Server $GroupsDomain -Credential $Cred

$GroupName = "Role EDMI User Bitbucket"
$GroupInfo = Get-ADGroup -Identity "$GroupName" -Server $GroupsDomain
Set-ADObject -Identity $GroupInfo -Add @{"member"=$Staff.DistinguishedName} -Server $GroupsDomain -Credential $Cred
