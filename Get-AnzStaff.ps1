if ($null -eq $UPNAccount){
    $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname
}
Connect-ExchangeOnline -UserPrincipalName $UPNAccount -ConnectionUri "https://outlook.office365.com/powershell-liveid/" 

# To create dynamic distribution groups
# New-DynamicDistributionGroup -Name 'O365 AU Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'Australia')"
# New-DynamicDistributionGroup -Name 'O365 NZ Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'New Zealand')"

$U1 = Get-DynamicDistributionGroup -Identity "O365 AU Mail Users"

# this doesn't work  it gets everyone  there is no equivalent for RecipientPreviewFilter
# $membersa = Get-EXORecipient $U1.users |select-object DisplayName , PrimarySmtpAddress

$members1 = Get-Recipient -RecipientPreviewFilter $U1.RecipientFilter |select-object DisplayName , PrimarySmtpAddress | sort DisplayName
Write-Host "Australian Staff"
$members1 | Format-Table 

$U2 = Get-DynamicDistributionGroup -Identity "O365 NZ Mail Users"
$members2 = Get-Recipient -RecipientPreviewFilter $U2.RecipientFilter  |select-object DisplayName , PrimarySmtpAddress | sort DisplayName
Write-Host "----------------------"
Write-Host "New Zealand Staff"
$members2 | Format-Table 
