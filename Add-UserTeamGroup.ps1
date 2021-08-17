<#
.SYNOPSIS
    Add User to MS Teams team  "ANZ EDMI"
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Add-UserTeamGroup -UserName "email address" 
    Creates user "new.user and copies some info from "existing.user" 
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserEMail
)


Connect-MicrosoftTeams

Get-Team -DisplayName "ANZ EDMI" | Add-TeamUser  -User "$UserEMail"