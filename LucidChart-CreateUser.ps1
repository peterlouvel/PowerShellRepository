<#
.SYNOPSIS
    Creating a new user in Bonus.ly
.DESCRIPTION
    Creating a new user in Bonus.ly
.EXAMPLE
    PS C:\> LucidChart-CreateUser -UserEmail "users.email@com"
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

# https://www.postman.com/

Get-Content ".\VariablesLucidChart.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

$Name = $UserEmail.Split(".@")

# $A1 = $Name[0] + "." + $Name[1]
# write-host $a1

$Header = @{"authorization" = "Bearer $token"}
# $Body = @{
#     userName    = $UserEmail
# 	email       = $UserEmail
# 	givenName   = $Name[0]
# 	familyName  = $Name[1]
#     Lucidchart = true
# }

# $Parameters = @{
#     Method 		= "POST"
#     Uri 		= "https://users.lucid.app/scim/v2/Users"
# 	Headers     = $Header
#     ContentType = "application/json"
# 	Body 		= ($Body | ConvertTo-Json) 
# }

# # $CreatedUserDetails = Invoke-RestMethod @Parameters

# ------------------------------------------------------------
# checking a user exists

$Parameters = @{
    Method 		= "GET"
    Uri 		= "https://users.lucid.app/scim/v2/Users?filter=email eq $UserEmail"
	Headers     = $Header
    ContentType = "application/json"
}

$UserDetails = Invoke-RestMethod @Parameters
Write-Host $UserDetails
