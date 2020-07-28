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
    [string]$GroupName
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = "edmi\"+$stYourAccount + "_"

if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential $AdminAccount
} 
$G1 = "confluence-space " + $GroupName + " (Design)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" -Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Description "view and edit content and settings" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $GroupName + " (Contrib)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" -Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Description "view and edit content" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $GroupName + " (Owner)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" -Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Description "view edit content and restrict pages" -Credential $EDMICREDS -Server "edmi.local"
$G1 = "confluence-space " + $GroupName + " (Read)"
NEW-ADGroup -Name "$G1" -GroupScope "DomainLocal" -Path "OU=confluence,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Description "read contents" -Credential $EDMICREDS -Server "edmi.local"
