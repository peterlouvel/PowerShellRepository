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
    [string]$ServerName
    ,[Parameter(Mandatory=$true)]
    [string]$UserName
)

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# This code will get the API $token from the variables.txt file
# This will retreive variables from a text file  don't put quotes around strings in the file
# token = 847d93094
Get-Content "$scriptPath\VariablesCredman.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
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

$PasswordListApiKeyTxt = ConvertTo-SecureString -String $PasswordListApiKey -AsPlainText -Force
$CredPasswordList = New-Object System.Management.Automation.PSCredential ($PasswordList, $PasswordListApiKeyTxt)

$Servers = Get-PasswordStateListPasswords -ApiKey $CredPasswordList -PasswordListId $PasswordListID

# Write-Host $Servers

$Password = ""

$ServerIsTrue = $False
$ServerID = 0
foreach ($Server in $Servers)
{
    if ($Server.Title -eq $ServerName) {
        #Server already in system
        $UserNameIsTrue = $False
        $ServerIsTrue = $True
        $ServerID = $Server.PasswordID
        $ServerTitle = $Server.Title

        foreach ($User in $Server.UserName){
            if ($User -eq $UserName) {
                #Username with Server already in system
                $UserNameIsTrue = $True
                $ServerPassword = $Server.Password
                # Write-Host "ServerTitle" -ForegroundColor Green 
                Write-Host "Server " -ForegroundColor Green -NoNewline
                Write-Host "$ServerTitle " -ForegroundColor Cyan -NoNewline
                Write-Host "with UserName " -ForegroundColor Green -NoNewline 
                Write-Host "$User " -ForegroundColor Cyan -NoNewline
                Write-Host "already in system with Password " -ForegroundColor Green -NoNewline 
                Write-Host "$ServerPassword"  -ForegroundColor Cyan 
            }
        }
        if ($UserNameIsTrue) {Break}
    }
}

if (!$UserNameIsTrue) {
    Write-Host "username is not true"
    #Create password in Password List
    $NewServerCred = New-PasswordStatePassword -ApiKey $CredPasswordList -PasswordListId $PasswordListID -Username $UserName -Title $ServerName -Description $ServerName -GeneratePassword
    Write-Host $NewServerCred.PasswordID
    Write-Host $NewServerCred.Password
    Write-Host $NewServerCred.UserName
    $ServerPassword = $NewServerCred.Password
} 

# $Session1 = New-PSSession -ComputerName "$ServerName" -Credential $Cred 
# $CreateUser = $False

# Invoke-Command -Session $Session1 -FilePath $Env:OneDriveCommercial\vscode\Set-LocalUserAccount.ps1 -ArgumentList "$UserName", "$ServerPassword"

# Remove-Pssession $Session1
