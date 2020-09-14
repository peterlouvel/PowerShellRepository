<#
    .SYNOPSIS
        Gets a users password expirey date
    .DESCRIPTION
        Gets a list of users in an AD Group
    .EXAMPLE
        get a single user from AU domain
        PS C:\> Get-UserExpiry -UsersAccount "username" -UsersDomain "au"
        
        get all active users from NZ domain
        PS C:\> Get-UserExpiry -UsersDomain "nz"
    .INPUTS
        An Active Directory username
    .OUTPUTS
        A user/s name and password expiry date
    .NOTES

#>

param(
    [Parameter(Mandatory=$False)]
    [string]$UsersAccount
    ,
    [Parameter(Mandatory=$False)]
    [string]$UsersDomain
)

if ($UsersAccount) {
    try {
        Get-ADUser "$UsersAccount" -Server $UsersDomain -Properties "Name", "LastLogonDate", "msDS-UserPasswordExpiryTimeComputed" | 
        Select-Object -Property "Name", "LastLogonDate", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 
        sort -Property Name
    } catch {
        Write-Host "User " -ForegroundColor  Green -NoNewline
        Write-Host "$UsersAccount " -ForegroundColor  Red -NoNewline
        write-host "does not exist" -ForegroundColor  Green
    }
} else {
    Get-ADUser  -Server $UsersDomain -filter {(Enabled -eq $True) -and (PasswordNeverExpires -eq $False)} -Properties "Name", "LastLogonDate",  "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object -Property "Name", "LastLogonDate" , @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 
    sort -Property Name
}

