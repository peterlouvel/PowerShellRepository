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
    [Parameter(Mandatory=$true)]
    [string]$User
)

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")

if ($stUserDomain -eq "au"){
    $End = "@edmi.com.au"
} else {
    $End = "@edmi.co.nz"
}
$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase + $End
$Account = $stUserAccount + $End

if ($null -eq $O365CREDS){
    $O365CREDS   = Get-Credential $Account
} 

# Give E3 licence to user

Connect-MSOLService -Credential $O365CREDS
# Remove-MsolUser –UserPrincipalName $NewUserMailBox"@edmi.com.au"
# Remove-MsolUser –UserPrincipalName $NewUserMailBox"@edmi.com.au" -RemoveFromRecycleBin
Get-ADUser $UserLowerCase | Set-MsolUser  -UsageLocation "AU"
Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:ENTERPRISEPACK" 