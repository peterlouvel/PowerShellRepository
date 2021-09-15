$ErrorActionPreference = 'SilentlyContinue'
cls
# To run this command you will need to have installed RSAT to get Active Directory PowerShell commands Install Active Directory Modules
$UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname

# Make a connection to Office 365 - to run this command you will need to Install/Update MS PowerShell Modules
Connect-ExchangeOnline -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -UserPrincipalName $UPNAccount -ShowProgress $true

# Set default calendar permissions for AU and NZ. Modify script for your own location if SG or UK
$users = Get-Mailbox -Resultsize Unlimited | Sort-Object Name 
foreach ($user in $users) {
    if ($user.UsageLocation -eq "Australia"-or $user.UsageLocation -eq "New Zealand"){
        Write-Host -ForegroundColor green "Setting permission for $($user.alias)...$($user.UsageLocation)"
        Set-MailboxFolderPermission -Identity "$($user.alias):\calendar" -User Default -AccessRights Reviewer
    }
}

