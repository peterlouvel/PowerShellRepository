
# $Session4 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Authentication Basic -AllowRedirection -Credential $O365CREDS   
# Import-PSSession $Session4 -AllowClobber


Connect-ExchangeOnline -UserPrincipalName $UPNAccount -ConnectionUri "https://outlook.office365.com/powershell-liveid/" 

# To create dynamic distribution groups
# New-DynamicDistributionGroup -Name 'O365 AU Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'Australia')"
# New-DynamicDistributionGroup -Name 'O365 NZ Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'New Zealand')"


$U1 = Get-DynamicDistributionGroup -Identity "O365 AU Mail Users"
$members1 = Get-EXORecipient $U1.users |select-object DisplayName , PrimarySmtpAddress
# $members1 = Get-Recipient -RecipientPreviewFilter $U1.RecipientFilter
Write-Host "Australian Staff"
$members1 | sort name | Format-Table 

$U2 = Get-DynamicDistributionGroup -Identity "O365 NZ Mail Users"
$members2 = Get-Recipient -RecipientPreviewFilter $U2.RecipientFilter 
Write-Host "----------------------"
Write-Host "New Zealand Staff"
$members2 | sort name | Format-Table 

Remove-PSSession $Session4