<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Create-MailContact -FirstName "AMS Bob" -LastName "Anderson" -ExternalEmail "emailaddress@somewhere.com" -Domain "au" 
    Creates a contact in 
       OU=Storm Production Clients,OU=Mail Contacts,OU=Mail,OU=EDMI Australia,DC=au,DC=edmi,DC=local
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
    [string]$FirstName
    ,
    [Parameter(Mandatory=$true)]
    [string]$LastName
    ,
    [Parameter(Mandatory=$true)]
    [string]$ExternalEmail
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain 
)

$First = (Get-Culture).TextInfo.ToTitleCase($FirstName)
$Last = (Get-Culture).TextInfo.ToTitleCase($LastName)
$FullName = $First + " " + $Last

$UserAlias = $FullName -replace(" ",".")

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($Domain -eq "au"){
    $DomainController = "AuBneDC11.au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
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

$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null -AllowClobber

$params = @{ 'ExternalEmailAddress' = "SMTP:$ExternalEmail";
             'DisplayName'          = "$FullName";
             'Name'                 = "$FullName";
             'Alias'                = "$UserAlias";
             'FirstName'            = "$First";
             'LastName'             = "$Last";
             'OrganizationalUnit'   = 'au.edmi.local/EDMI Australia/Mail/Mail Contacts/Storm Production Clients';
             'DomainController'     = "$DomainController"
            }

Write-Host "--New Mail Contact--"
New-MailContact @params
# Write-Host "- $ExternalEmail - $FullName -"
Write-Host " - Waiting 30 Seconds for AD to sync before makeing changes to the contacts description"
Start-Sleep -s 30
Get-ADObject -LDAPFilter "objectClass=Contact" -Properties * | where-object {$_.Name -like "$FullName"} | Set-ADObject -Description "$ExternalEmail" -Credential $Cred
Exit-PSSession
Remove-PSSession $Session1

