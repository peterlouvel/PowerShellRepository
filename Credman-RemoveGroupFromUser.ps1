<#
.SYNOPSIS
    Create password in Credman for a server and then create/update the password on the server
.DESCRIPTION
    Create password in Credman for a server and then create/update the password on the server
.EXAMPLE
    PS C:\> Create-CredmanServerPassword -ServerName "-ServerName" -UserName "UserName"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
)

# This code will get the API $token from the variables.txt file
# This will retreive variables from a text file  don't put quotes around strings in the file
# token = 847d93094
Get-Content ".\VariablesCredman.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

<#   --- The  .\VariablesCredman.txt  file to have the following info

PasswordList = Server Admin Accounts Name Group
#     can have spaces in the name  don't use any quotes
PasswordListID = 38747
#     use the number given from PasswordState for your List ID
PasswordListApiKey = b628cda3964fe358c36ab39ad45adfed3
#     the key exactly as given for the List API

#>

# Write-Host $PasswordList
# Write-Host $PasswordListID
# Write-Host $PasswordListApiKey

Initialize-PasswordStateRepository -ApiEndpoint 'https://credman.nz.edmi.local/api/'

# Have to wait till Version  9 of Credman