<#
.SYNOPSIS
    Creates a Distribution List 
.DESCRIPTION
    Creates a Distribution List in either
        OU=Distribution,OU=Mail,OU=EDMI Australia,DC=au,DC=edmi,DC=local
    or
        OU=Distribution,OU=Mail,OU=EDMI New Zealand,DC=nz,DC=edmi,DC=local

.EXAMPLE
    PS C:\> Create-DistList -Name "Test List" -Description "A Test Distribution List" -Domain "au" 

.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz
#>


param(
    [Parameter(Mandatory=$true)]
    [string]$Name
    ,
    [Parameter(Mandatory=$false)]
    [string]$Description = "A Distribution List"
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain 
)

$UserAlias = $Name -replace(" ","")

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($Domain -eq "au"){
    $DomainController = "AuBneDC11.au.edmi.local"
    $OU = "au.edmi.local/EDMI Australia/Mail/Distribution"
    $AdminAccount1 = "au\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $OU = "nz.edmi.local/EDMI New Zealand/Mail/Distribution"
    $AdminAccount1 = "nz\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    }
} else {
    Write-Host "Domain should be AU or NZ"
    exit
}
Write-Host
Write-Host "Setup your Credentials for accessing the local exchange server" -ForegroundColor Cyan  
Write-Host $AdminAccount1

$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch3.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null -AllowClobber
$SamName = "Distint " + $Name 
Write-Host "--New Distribution List--"
new-DistributionGroup -Name $Name -DisplayName $Name -OrganizationalUnit $OU -SamAccountName $SamName -Alias $UserAlias -Domain $DomainController 
Write-Host " - Waiting 30 Seconds for AD to sync before makeing changes to the email list description"
Start-Sleep -s 30
Get-ADObject -LDAPFilter "objectClass=Group" -Properties * -Server $DomainController | where-object {$_.Name -like "$Name"} | Set-ADObject -Description "$Description" -Server $DomainController -Credential $Cred

Exit-PSSession
Remove-PSSession $Session1

