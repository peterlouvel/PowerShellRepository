#Requires -Version 4.0
Add-Type -AssemblyName System.Web
Import-Module ActiveDirectory

$csvtempf = "c:\scripts\BrisbaneHQ.csv" #[System.IO.Path]::GetTempFileName()
if ($csvtempf -eq $null) {
    Write-Error "Could not get a tempfile"
    Exit
}

if (Test-Path -Path $csvtempf){
    Remove-Item $csvtempf
}

##############################################################
##
## Active Directory exporter configuration
##
##############################################################
$appkey = 'zCQT4M2nt532tf9M'
$adprops = 'ObjectGUID','CanonicalName','GivenName','Surname','DisplayName','Title','EmailAddress','Company','OfficePhone','MobilePhone','Office','Department','Country'
$exportphotos = $false

#
# If $searchbases is set the export runs at each supplied ActiveDirectory paths. $searchbases is a comma seperated list of AD paths, uncomment to enable.
#
#$searchbases = 'OU=North America,OU=Users,DC=company,DC=local', 'OU=Asia,OU=Users,DC=company,DC=local'
$searchbases  = 'OU=Melbourne,OU=Employees,OU=EDMI Australia,DC=au,DC=edmi,DC=local', 'OU=Brendale,OU=Employees,OU=EDMI Australia,DC=au,DC=edmi,DC=local', 'OU=Brisbane HQ,OU=Employees,OU=EDMI Australia,DC=au,DC=edmi,DC=local'

#
# If Photo export is enabled, export thumbnailPhoto image attribute in BASE64
#
if ($exportphotos) {
    $adprops += @{Name="thumbnailPhoto";Expression={[System.Convert]::ToBase64String($_.thumbnailPhoto)}}
}

#
# Extract the staff list either over whole tree or by listed paths. This can be customized as needed.
#
Write-Host "Exporting users..."
if ($searchbases) {
    # Run `Get-ADUser` for every path in $searchbases
    $searchbases | %{ Get-ADUser -Filter * -SearchBase $_ -Property * -Server au.edmi.local } |
    Where {$_.enabled -eq $true} |
    Select $adprops | Export-Csv $csvtempf -Encoding UTF8 -NoTypeInformation
 } else {
    Get-ADUser -Filter * -Property * -Server au.edmi.local | Where {$_.enabled -eq $true} |
    Select $adprops | Export-Csv $csvtempf -Encoding UTF8 -NoTypeInformation
 }

# Extract completed
if ((Get-Item $csvtempf).length -eq 0) {
    Write-Host "Error: Get-ADUser did not return any data"
    Exit
}

##############################################################
##
## End of configuration, prepare to upload the extract.
##
##############################################################

$uri = 'https://api.whosonlocation.com/v1/sync'
$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
if ($proxy -And -Not $proxy.IsBypassed($uri)) {
    $proxyUri = $proxy.GetProxy($uri)
    Write-Host "Using proxy $proxyUri"
    $global:PSDefaultParameterValues = @{
        'Invoke-RestMethod:Proxy'=$proxyUri
        '*:ProxyUseDefaultCredentials'=$true
    }
}

$scripthash = '';
If ($MyInvocation.InvocationName) {
    # MD5 of this file, used to detect multiple script copies and correctly prune entities
    $scripthash = (Get-FileHash -Path $MyInvocation.InvocationName -Algorithm MD5).Hash
}

# Only Authorization header is required, X-Wol-* are optional metadata.
$headers = @{
    'Authorization' = 'APIKEY ' + $appkey;
    'Accept' = 'application/json';
    'X-Wol-PSVer' = $PSVersionTable.PSVersion;
    'X-Wol-SyncPortalVer' = '34';
    'X-Wol-Filehash' = $scripthash;
}

Write-Host "Uploading data to WhosOnLocation..."
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $resp = Invoke-RestMethod -Uri $uri -Method 'PUT' -ContentType 'text/csv; charset=UTF-8' -Headers $headers -InFile $csvtempf -TimeoutSec 0 | Format-List
} catch [Exception] {
    Write-Host "Error connecting to $uri"
    Write-Host $_.Exception.Message
    if ($_.Exception.Response) {
        $response = $_.Exception.Response.GetResponseStream()
        $s = $response.Seek(0, 0)
        $reader = New-Object System.IO.StreamReader($response)
        $reader.ReadToEnd()
    }
} finally {
    # Remove-Item $csvtempf
}
