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
)


Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select DisplayName
# Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName