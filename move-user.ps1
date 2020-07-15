<#
.SYNOPSIS
    Moves a user from NZ to AU domain
.DESCRIPTION
    Moves a user from NZ to AU domain

.EXAMPLE
    PS C:\> Move-User -UserName "FirstName.LastName" 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Note1: Make sure the user is NOT part of any Global groups
    Note2: Remove ExchangeActiveSynDevices on the users account in ADUC (view as containers)

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$DomainAdminAccount  = $stYourAccount + "_"

if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential "edmi\$DomainAdminAccount"
} 

$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'

Get-ADUser "$UserAccount" -Server "nzwlgdc2.nz.edmi.local" | Move-ADObject -TargetPath "OU=Employees,OU=EDMI Australia,DC=au,DC=edmi,DC=local" -Credential $EDMICREDS -server "nzwlgdc2.nz.edmi.local" -TargetServer "aubnedc11.au.edmi.local"
