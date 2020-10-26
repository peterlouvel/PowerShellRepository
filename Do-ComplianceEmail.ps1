
param(
    [Parameter(Mandatory=$true)]
    [string]$NameSearch
)

if ($null -eq $UPNAccount){
    $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname
}
Connect-ExchangeOnline -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -UserPrincipalName $UPNAccount -ShowProgress $true
$D1 = (get-date).AddDays(-2).ToString("MM/dd/yyyy")
New-ComplianceSearch -Name "Search $NameSearch" -ExchangeLocation all -ContentMatchQuery "received>=$D1 AND subject:$NameSearch"
Start-ComplianceSearch -Identity "Search $NameSearch"
Get-ComplianceSearch -Identity "Search $NameSearch"
$NameSearchPurge = $NameSearch + "_Purge"
Write-Host 
Write-Host " To get the status of the search"
Write-Host "Get-ComplianceSearch -Identity ""Search $NameSearch"""
# Write-Host "New-ComplianceSearchAction -SearchName ""Search $NameSearch"" -Preview"
Write-Host
Write-Host "New-ComplianceSearchAction -SearchName ""Search $NameSearch"" -Purge -PurgeType SoftDelete"
Write-Host
Write-Host "get-ComplianceSearchAction -Identity ""Search $NameSearchPurge"""
Write-Host
Write-Host " When you have finished with the search - delete it" 
Write-Host "remove-ComplianceSearch -Identity ""Search $NameSearch"""


# get list of email addresses
# (Get-ComplianceSearch -Identity "Search $NameSearch").SuccessResults
# this will required the URI to change
# Connect-ExchangeOnline  -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -UserPrincipalName $UPNAccount -ShowProgress $true

