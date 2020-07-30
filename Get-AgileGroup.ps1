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

$Staff = Get-ADGroupMember -Identity "$Group" -Server "edmi.local" -Recursive |
  Get-ADUser -Properties Mail,GivenName,Surname |
  Select-Object Mail 
  
$Staff 

$Staff | Export-Csv -Path "c:\temp\$GroupName.csv" -NoTypeInformation
