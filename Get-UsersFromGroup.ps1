<#
.SYNOPSIS
    Gets a list of users in an AD Group
.DESCRIPTION
    Gets a list of users in an AD Group
.EXAMPLE
    PS C:\> Get-UsersFromGroup -GroupName "Group Name in AD" 
    
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$GroupName
    ,[Parameter(Mandatory=$true)]
    [string]$Domain
)

Get-ADGroupMember -Identity $GroupName -Recursive -Server $Domain | Get-ADUser -Property DisplayName | Select-Object DisplayName | Sort-Object DisplayName
# Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName