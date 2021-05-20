<#
.SYNOPSIS
    Add a User to a group
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Add-UserToGroup -UserName "bob.hope" -UsersDomain "au" -GroupName "someGroup" -GroupDomain "au"
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
    ,[Parameter(Mandatory=$true)]
    [string]$GroupName
    ,[Parameter(Mandatory=$false)]
    [string]$GroupsDomain = "z"
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}
if ($GroupsDomain -eq "z"){
    $GroupsDomain=$stYourDomain
}

if ($null -eq $Cred){
        $Cred = Get-Credential "edmi\$AdminAccount"
}

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

if ($GroupsDomain -eq "au"){
    $GroupsDomainFQN = "au.edmi.local"
} elseif ($GroupsDomain -eq "nz"){
    $GroupsDomainFQN = "nz.edmi.local"
} elseif ($GroupsDomain -eq "uk"){
    $GroupsDomainFQN = "uk.edmi.local"
} elseif ($GroupsDomain -eq "sg"){
    $GroupsDomainFQN = "sg.edmi.local"
} elseif ($GroupsDomain -eq "edmi"){
    $GroupsDomainFQN = "edmi.local"
} else {
    Write-Host
    Write-Host "Group Domain should be AU, NZ, UK, SG, EDMI" -ForegroundColor Red 
    exit
}

# Write-Host "$UserName | $UsersDomain = $UsersDomainFQN | $GroupsDomain = $GroupsDomainFQN    "
$Staff = Get-ADUser -Identity "$UserName" -Server "$UsersDomainFQN"  

$GroupInfo = Get-ADGroup -Identity "$GroupName" -Server $GroupsDomain
Set-ADObject -Identity $GroupInfo -Add @{"member"=$Staff.DistinguishedName} -Server $GroupsDomain -Credential $Cred