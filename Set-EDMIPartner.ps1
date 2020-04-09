$credential = $O365CREDS
$refreshToken = '<RefreshToken>'
$TenantEDMI = "74430ce8-49b7-4f72-8b54-1c334958bf25"

New-PartnerAccessToken -ApplicationId '00000002-0000-0000-c000-000000000000' -Credential $credential -RefreshToken $refreshToken -Scopes 'https://api.partnercenter.microsoft.com/user_impersonation' -ServicePrincipal -Tenant $TenantEDMI



$aadGraphToken = New-PartnerAccessToken -ApplicationId 'xxxx-xxxx-xxxx-xxxx' -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.windows.net/.default' -ServicePrincipal -Tenant 'yyyy-yyyy-yyyy-yyyy'
$graphToken = New-PartnerAccessToken -ApplicationId 'xxxx-xxxx-xxxx-xxxx' -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Tenant 'yyyy-yyyy-yyyy-yyyy'

Connect-AzureAD -AadAccessToken $aadGraphToken.AccessToken -AccountId 'peter.louvel@edmi.com.au' -MsAccessToken $graphToken.AccessToken



$user = "MyDomain\MyUser"
$pw = ConvertTo-SecureString "PassWord!" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw
New-AzureAutomationCredential -AutomationAccountName "Contoso17" -Name "MyCredential" -Value $cred