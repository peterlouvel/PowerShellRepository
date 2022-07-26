<#
.SYNOPSIS
    Getting app info OKTA
.DESCRIPTION
    OKTA
.EXAMPLE
    PS C:\> Okta-GetApp -App "App Name"
.INPUTS
    .
.OUTPUTS
    .
.NOTES
 #>

param(
    [Parameter(Mandatory=$true)]
    [string]$App
)

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# https://www.postman.com/

# This code will get the API $token from the variables.txt file
# This will retreive variables from a text file  don't put quotes around strings in the file
# token = 847d93094
Get-Content "$scriptPath\VariablesOKTA.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

# $token = "get API token for bonus.ly"   # use quotes here if the token is entered into your script directly
$Name = $App

$Header = @{"authorization" = "SSWS $token"}

# ------------------------------------------------------------
# checking a user exists

$Parameters = @{
    Method 		= "GET"
    Uri 		= "https://edmi.okta.com/api/v1/apps/$AppID"
	Headers     = $Header
    ContentType = "application/json"
}

$AppDetails = Invoke-RestMethod @Parameters
$AppDetails.result
