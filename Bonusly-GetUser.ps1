<#
.SYNOPSIS
    Creating a new user in Bonus.ly
.DESCRIPTION
    Creating a new user in Bonus.ly
.EXAMPLE
    PS C:\> Bonusly-GetUser -UserEmail "users.email@com"
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

# This code will get the API $token from the variables.txt file
# This will retreive variables from a text file  don't put quotes around strings in the file
# token = 847d93094
Get-Content ".\VariablesBonusly.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

# $token = "get API token for bonus.ly"   # use quotes here if the token is entered into your script directly
$Name = $UserEmail.Split(".@")

$Header = @{"authorization" = "Bearer $token"}

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
