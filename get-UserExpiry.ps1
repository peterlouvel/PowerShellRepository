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
    default domain is au
    you can use sg, nz, uk domains
#>

param(
    [Parameter(Mandatory=$False)]
    [string]$UsersAccount
    ,
    [Parameter(Mandatory=$False)]
    [string]$UsersDomain="au"
)

if ($UsersAccount) {
    try {
        Get-ADUser "$UsersAccount" -Server $UsersDomain -Properties "Name", "pwdLastSet", "LastLogonDate", "LastLogon", "msDS-UserPasswordExpiryTimeComputed" | 
        Select-Object -Property "Name", "LastLogonDate", @{Name="LastLogon";Expression={[datetime]::FromFileTime($_."LastLogon")}}, @{Name="PWD Last Changed";Expression={[datetime]::FromFileTime($_."pwdLastSet")}}, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
        format-table 
    } catch {
        Write-Host "User " -ForegroundColor Green -NoNewline
        Write-Host "$UsersAccount " -ForegroundColor Red -NoNewline
        write-host "does not exist" -ForegroundColor Green
    }
} else {
    Get-ADUser -Server $UsersDomain -filter {(Enabled -eq $True) -and (PasswordNeverExpires -eq $False)} -Properties "Name", "pwdLastSet", "LastLogonDate", "LastLogon",  "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object -Property "Name", "LastLogonDate", @{Name="LastLogon";Expression={[datetime]::FromFileTime($_."LastLogon")}}, @{Name="PWD Last Changed";Expression={[datetime]::FromFileTime($_."pwdLastSet")}}, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 
    sort -Property Name |
    format-table 
}

Write-Host "There is a difference between LastLogonDate and LastLogon"
Write-Host "Read artical to find out more"
Write-Host "https://community.spiceworks.com/topic/2062846-lastlogon-lastlogondate-and-lastlogontimestamp"