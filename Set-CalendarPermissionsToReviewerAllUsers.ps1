#  https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps

# install  ==>  Microsoft.Online.CSE.PSModule.Client.application  
# from  ===>  https://outlook.office365.com/ecp/

# [String] ${stUserDomain}, [String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
# Write-Host "Run this command with your AU or NZ Domain credentials that has admin access in Office 365"

# # Setup correct ending for UPN
# if ($stUserDomain -eq "au"){
#     $End = "@edmi.com.au"
# } elseif ($stUserDomain -eq "nz"){
#     $End = "@edmi.co.nz"
# } else {
#     Write-Host "You are not running in an AU or NZ Domain"
#     exit
# }

# $UPNAccount = "$stUserAccount"+"$End"
$UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname
# This is if you don't have the $AppCREDS already setup and saved
if ($null -eq $AppCREDS){
	# doing this so we don't change the settings for all EDMI in Singapore and UK
    Write-Host "Type in the Application Credential you created https://docs.microsoft.com/en-us/azure/active-directory/user-help/multi-factor-authentication-end-user-app-passwords#create-and-delete-app-passwords-using-the-office-365-portal"
    $AppCREDS   = Get-Credential $UPNAccount
} 

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -AllowRedirection -Credential $AppCREDS -Authentication Basic
Import-PSSession $Session
$users = Get-Mailbox -Resultsize Unlimited
foreach ($user in $users) {
    if ($user.UsageLocation -eq "Australia"-or $user.UsageLocation -eq "New Zealand"){
        Write-Host -ForegroundColor green "Setting permission for $($user.alias)...$($user.UsageLocation)"
        Set-MailboxFolderPermission -Identity "$($user.alias):\calendar" -User Default -AccessRights Reviewer
    }
}


