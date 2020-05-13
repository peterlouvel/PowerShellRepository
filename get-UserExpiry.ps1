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
    [string]$User
)

if ($User) {
    try {
        Get-ADUser "$User" -Properties "Name", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | sort -Property Name
    } catch {
        Write-Host "User " -ForegroundColor  Green -NoNewline
        Write-Host "$user " -ForegroundColor  Red -NoNewline
        write-host "does not exist" -ForegroundColor  Green
    }
} else {
    Get-ADUser  -filter {(Enabled -eq $True) -and (PasswordNeverExpires -eq $False)} -Properties "Name", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | sort -Property Name
}



