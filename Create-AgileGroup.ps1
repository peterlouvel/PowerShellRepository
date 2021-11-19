<#
.SYNOPSIS
    Update Agile Group in Root EDMI
.DESCRIPTION
    Update Agile Group in Root EDMI
.EXAMPLE
    .
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

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

$AdminAccount1 = "edmi\"+$AdminAccount
if ($null -eq $Cred){
    $Cred = Get-Credential $AdminAccount1
} 

Write-Host
Write-Host "Setting up your Credentials for accessing the local exchange server " -ForegroundColor Cyan -NoNewLine
Write-Host $AdminAccount1

$Group = "Role EDMI Team " + $GroupName

New-ADGroup -Credential $Cred -Name "$Group" -Path "OU=agile,OU=roles,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -GroupScope "Universal" -Server "edmi"
.\Create-DistList.ps1 -Name "$GroupName" -Description "" -Domain "au" 

Add-AdGroupMember -Credential $Cred -Identity "Role EDMI Team Super Chief" -Members "$Group" -Server "edmi"