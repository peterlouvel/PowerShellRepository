#  https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps

# install  ==>  Microsoft.Online.CSE.PSModule.Client.application  
# from  ===>  https://outlook.office365.com/ecp/

[String] ${stUserDomain}, [String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")

# Setup correct ending for UPN
if ($stUserDomain -eq "au"){
    $End = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $End = "@edmi.co.nz"
} else {
    Write-Host "Run this command with your AU or NZ Domain credentials that can access Office 365"
    exit
}

$UPNAccount = "$stUserAccount"+"$End"

# read-host -assecurestring | convertfrom-securestring -key (1..16) | out-file "$Env:OneDriveCommercial/a2"

$AppPassword = get-content "$Env:OneDriveCommercial/a2" | convertto-securestring  -key (1..16)
$AppCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $UPNAccount, $AppPassword

# $Session = Connect-EXOPSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -AllowRedirection -Credential $AppCred -Authentication 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -AllowRedirection -Credential $AppCred -Authentication Basic
Import-PSSession $Session
$users = Get-Mailbox -Resultsize Unlimited
foreach ($user in $users) {
   Write-Host -ForegroundColor green "Setting permission for $($user.alias)..."
   Set-MailboxFolderPermission -Identity "$($user.alias):\calendar" -User Default -AccessRights Reviewer
}
#kdqtygvmljqwsbhm#a
