<#
.SYNOPSIS
    Creates groups for confluence
.DESCRIPTION
    Creates groups for confluence

.EXAMPLE
    PS C:\> Copy-GroupMembers -SrcGroup "Source Group" -DstGroup "Destination Group"

.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SrcGroup
    ,[Parameter(Mandatory=$true)]
    [string]$DstGroup
)

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = "edmi\"+$stYourAccount + "_"

if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential $AdminAccount
} 

Add-ADGroupMember -Identity $DstGroup -members (Get-ADGroupMember $SrcGroup -Server "edmi.local") -Server "edmi.local" -Credential $EDMICREDS