<#
.SYNOPSIS
    Gets a users password expirey date
.DESCRIPTION
    Gets a list of users in an AD Group
.EXAMPLE
    get a single user
    PS C:\> Get-UsersFromGroup -User [username]
    
    get all active users
    PS C:\> Get-UsersFromGroup
.INPUTS
    An Active Directory username
.OUTPUTS
    A user/s name and password expiry date
.NOTES

#>

param(
    [Parameter(Mandatory=$False)]
    [string]$UsersAccount
)

if ($UsersAccount) {
    try {
        Get-ADUser "$UsersAccount" -Properties "Name", "LastLogonDate", "msDS-UserPasswordExpiryTimeComputed" | 
        Select-Object -Property "Name", "LastLogonDate", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 
        sort -Property Name
    } catch {
        Write-Host "User " -ForegroundColor  Green -NoNewline
        Write-Host "$UsersAccount " -ForegroundColor  Red -NoNewline
        write-host "does not exist" -ForegroundColor  Green
    }
} else {
    Get-ADUser  -filter {(Enabled -eq $True) -and (PasswordNeverExpires -eq $False)} -Properties "Name", "LastLogonDate",  "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object -Property "Name", "LastLogonDate", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 
    sort -Property Name
}



