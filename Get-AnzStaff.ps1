
$Session4 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Authentication Basic -AllowRedirection -Credential $O365CREDS 
Import-PSSession $Session4

# To create dynamic distribution groups
# New-DynamicDistributionGroup -Name 'O365 AU Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'Australia')"
# New-DynamicDistributionGroup -Name 'O365 NZ Mail Users' -RecipientFilter "(RecipientType -eq 'UserMailbox') -and (CountryOrRegion -eq 'New Zealand')"

Write-Host "Australian Staff"
$U1 = Get-DynamicDistributionGroup -Identity "O365 AU Mail Users"
Get-Recipient -RecipientPreviewFilter $U1.RecipientFilter

Write-Host "New Zealand Staff"
$U2 = Get-DynamicDistributionGroup -Identity "O365 NZ Mail Users"
Get-Recipient -RecipientPreviewFilter $U2.RecipientFilter