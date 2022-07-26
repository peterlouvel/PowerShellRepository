<#
.SYNOPSIS
    Creating a new user in Bonus.ly
.DESCRIPTION
    Creating a new user in Bonus.ly
.EXAMPLE
    PS C:\> send-sms -PhoneNumberReceiver 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
 #>

param(
    [Parameter(Mandatory=$true)]
    [string]$PhoneNumberReceiver,
    [Parameter(Mandatory=$true)]
    [string]$Message    
)

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# https://www.postman.com/

Get-Content "$scriptPath\VariablesSMSBroadcast.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $token")

$response = Invoke-RestMethod "http://api.smsbroadcast.com.au/api.php?username=$username&password=$password&from=$account&to=$PhoneNumberReceiver&message=$Message" -Method 'POST' -Headers $headers
$response | ConvertTo-Json
