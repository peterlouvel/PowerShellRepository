<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>


param(
    # [Parameter(Mandatory=$false)]
    # [PSCredential]$Cred,
    [Parameter(Mandatory=$true)]
    [string]$User
)


$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase +"@edmi.com.au"

if ($null -eq $Cred){
    $Cred   = Get-Credential "au\peterl_"
} 

$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null
Enable-Mailbox -Identity $UserLowerCase -Database "Mailbox Database Australian Users" -DomainController AuBneDC11.au.edmi.local
Exit-PSSession
Remove-PSSession $Session1


if ($null -eq $O365CREDS){
    $O365CREDS   = Get-Credential "peter.louvel@edmi.com.au"
} 


$Session2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $O365CREDS -Authentication Basic -AllowRedirection

Import-PSSession $Session2 3>$null

Connect-MsolService -Credential $O365CREDS
New-MoveRequest -Identity $UserLowerCase -Remote -RemoteHostName edmibneexch3.edmi.local -TargetDeliveryDomain edmi.mail.onmicrosoft.com -RemoteCredential $Cred -BadItemLimit 1000

Get-MoveRequest | Get-MoveRequestStatistics

Remove-PSSession $Session2