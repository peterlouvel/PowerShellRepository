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
Get-Content "$scriptPath\VariablesBonusly.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

# $token = "get API token for bonus.ly"   # use quotes here if the token is entered into your script directly
$Name = $UserEmail.Split(".@")

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

$Header = @{"authorization" = "Bearer $tokenRW"}
$Body = @{
	email       = $UserEmail
	first_name  = $Name[0]
	last_name   = $Name[1]
    time_zone   = $timeZone
	country     = $countrycode
    # location    = $location  # not in the system as location
}

$Parameters = @{
    Method 		= "POST"
    Uri 		= "https://bonus.ly/api/v1/users"
	Headers     = $Header
    ContentType = "application/json"
	Body 		= ($Body | ConvertTo-Json) 
}

$CreatedUserDetails = Invoke-RestMethod @Parameters

# ------------------------------------------------------------
# checking a user exists

$Parameters = @{
    Method 		= "GET"
    Uri 		= "https://bonus.ly/api/v1/users?limit=1&email=$UserEmail"
	Headers     = $Header
    ContentType = "application/json"
}

$UserDetails = Invoke-RestMethod @Parameters
$UserDetails.result
