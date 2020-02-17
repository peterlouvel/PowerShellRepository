$user = Read-Host "Enter Name"

$Userinfo = Get-ADUser -Filter * -Properties LockedOut |
    Where-Object { $_.SAMAccountName -like "*$user*" } |
    Select-Object -Property SamAccountName, DistinguishedName, LockedOut |
    Out-GridView -PassThru

if ($Userinfo.lockedout -eq "True") {
    Write-Host -f red "Account locked"
    Write-Host""
    Write-Host""
    Write-Host "Unlocking Account"
    Unlock-ADAccount $Userinfo.SamAccountName
} Else {
    Write-Host -f Green "Account is Not Locked out"
}