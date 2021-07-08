<#
.SYNOPSIS
    Create a new Computer account in OU=Laptops,OU=Workstations,OU=Computers,OU=EDMI Australia,DC=au,DC=edmi,DC=local
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Create-Computer -ComputerName "LT-BNE-aaa" 

.INPUTS
    .
.OUTPUTS
    .
.NOTES
    .
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

New-ADComputer -Name "$ComputerName" -SAMAccountName "$ComputerName" -Path "OU=Laptops,OU=Workstations,OU=Computers,OU=EDMI Australia,DC=au,DC=edmi,DC=local"  -Credential $Cred
