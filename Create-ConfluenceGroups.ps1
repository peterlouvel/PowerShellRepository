<#
.SYNOPSIS
    Creates groups for confluence
.DESCRIPTION
    Creates groups for confluence

.EXAMPLE
    PS C:\> Create-Create-ConfluenceGroup -Name "Test Group" -Description "A Test Distribution List"  

.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Name
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = "edmi\"+$stYourAccount + "_"

if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential $AdminAccount
} 
$G1 = "confluence-space " + $Name + " (Design)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" –Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $Name + " (Contrib)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" –Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $Name + " (Owner)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" –Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $Name + " (Read)"
Write-Host "$G1"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" –Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Credential $EDMICREDS -Server "edmi.local"
