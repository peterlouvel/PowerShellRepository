<#
.SYNOPSIS
    Create password in Credman for a server
.DESCRIPTION
    Create password in Credman for a server
.EXAMPLE
    PS C:\> Create-CredmanServerPassword -ServerName "-ServerName" -UserName "UserName"
    
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerName
    ,[Parameter(Mandatory=$true)]
    [string]$UserName
)

Initialize-PasswordStateRepository -ApiEndpoint 'https://credman.nz.edmi.local/api/'
 
#Setup Password List to use
$PasswordList = "thePasswordListName"
$PasswordListID = theListIDnumber
$PasswordListApiKey = "thePasswordListApiKey"
$PasswordListApiKeyTxt = ConvertTo-SecureString -String $PasswordListApiKey -AsPlainText -Force
$CredPasswordList = New-Object System.Management.Automation.PSCredential ($PasswordList, $PasswordListApiKeyTxt)

$Servers = Get-PasswordStateListPasswords -ApiKey $CredPasswordList -PasswordListId $PasswordListID   

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
    #Create password in Password List
    $NewServerCred = New-PasswordStatePassword -ApiKey $CredPasswordList -PasswordListId $PasswordListID -Username $UserName -Title $ServerName -Description $ServerName -GeneratePassword
    $NewServerCred.PasswordID
    $NewServerCred.Password
    $NewServerCred.UserName
} 

# $ServerIsTrue
# $UserNameIsTrue
