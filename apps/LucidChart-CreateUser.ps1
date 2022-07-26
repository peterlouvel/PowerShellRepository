<#
.SYNOPSIS
    Creating a new user in Bonus.ly
.DESCRIPTION
    Creating a new user in Bonus.ly
.EXAMPLE
    PS C:\> Bonusly-CreateUser -UserEmail "users.email@com"
.INPUTS
    .
.OUTPUTS
    .
.NOTES
 #>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserEmail
)

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# https://www.postman.com/

# This code will get the API $token from the variables.txt file
# This will retreive variables from a text file  don't put quotes around strings in the file
# token = 847d93094
Get-Content "$scriptPath\VariablesLucidChart.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

# $token = "get API token for bonus.ly"   # use quotes here if the token is entered into your script directly
$Name = $UserEmail.Split(".@")

$First = $Name[0]
$Last = $Name[1]

$FullName = $First + " " + $Last

# Write-Host $name[4]

if ($name[4] -eq "nz") {
    $timeZone = "Pacific/Auckland"
    $countrycode = "nz"
    $location = "Wellington"
}
# if ($name[4] -eq "au") {
#     $timeZone = "Australia/Queensland"
#     $countrycode = "au"
#     $location = "Brisbane"
# }
if ($name[4] -eq "au") {
    $timeZone = "Australia/Melbourne"
    $countrycode = "au"
    $location = "Melbourne"
}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $token")

$headers.Add("Content-Type", "application/json")

$body = "{
            `"schemas`": [
                `"urn:ietf:params:scim:schemas:core:2.0:User`",
                `"urn:lucidchart:schemas:1.0:User`",
                `"urn:ietf:params:scim:schemas:extension:enterprise:2.0:User`"
                ],
            `"userName`": `"$UserEmail`",
            `"name`": {
                `"formatted`": `"$FullName`",
                `"givenName`": `"$First`",
                `"familyName`": `"$Last`"
                },
            `"displayName`": `"$FullName`",
            `"emails`": [{ `"primary`": true, `"value`": `"$UserEmail`" }],
            `"active`": true,
            `"urn:lucidchart:schemas:1.0:User`" : {`"canEdit`": false},
            `"urn:ietf:params:scim:schemas:extension:lucid:2.0:User`": 
                {`"productLicenses`": 
                    {`"Lucidchart`": true,`"Lucidspark`": false,`"LucidscaleCreator`": false,`"LucidscaleExplorer`": false}
                }
            }"
Write-Host $body

$response = Invoke-RestMethod 'https://users.lucid.app/scim/v2/Users' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json

# ------------------------------------------------------------
# checking a user exists

