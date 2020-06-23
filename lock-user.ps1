<#
.SYNOPSIS
    Lock a users account in AD
.DESCRIPTION
    Lock a users account in AD
.EXAMPLE
    PS C:\> Lock-User -UserName "AMS" -UsersDomain "au" 
    or to lock an account in your current domain
    PS C:\> Lock-User -UserName "AMS"
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz

    To find accounts that are locked
    Search-ADAccount -LockedOut -UsersOnly | Select-Object Name, SamAccountName
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

.".\IncludePWL.ps1"

$Userinfo = Get-ADUser -Filter * -Properties LockedOut -Server $DomainController |
    Where-Object { $_.SAMAccountName -like "*$UserName*" } |
    Select-Object -Property SamAccountName, DistinguishedName, UserPrincipalName, LockedOut |
    Out-GridView -PassThru

# Requires -Version 3.0
# Requires -Modules ActiveDirectory, GroupPolicy

# Import-Module ActiveDirectory
# Import-Module GroupPolicy

Write-Host 

if ($Userinfo.SamAccountName){
    if ($Userinfo.lockedout -eq "True") {
        Write-Host -f red "Account already locked"
    } Else {
        if ($LockoutBadCount = ((([xml](Get-GPOReport -Name "Default Domain Policy" -Server $DomainController -ReportType Xml)).GPO.Computer.ExtensionData.Extension.Account |
            Where-Object name -eq LockoutBadCount).SettingNumber)) {
            $Password = ConvertTo-SecureString 'NotMyPassword' -AsPlainText -Force
            for ($i = 1; $i -le $LockoutBadCount; $i++) { 
                Invoke-Command -ComputerName $DomainController {Get-Process
                } -Credential (New-Object System.Management.Automation.PSCredential (($Userinfo.UserPrincipalName), $Password)) -ErrorAction SilentlyContinue            
            }
            Write-Output "$($Userinfo.SamAccountName) has been locked out: $((Get-ADUser -Identity $Userinfo.SamAccountName -Server $DomainController -Properties LockedOut).LockedOut)"
        }
    }
}else{
    Write-Host -f red "No account selected"
    Write-Host
}