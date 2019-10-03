<#
.SYNOPSIS
    Run this when the users account is synced to O365
.DESCRIPTION
    Run this when the users account is synced to O365
.EXAMPLE
    PS C:\> Enable-O365Email -User "user.name" -Domain "au"
    Creates the users mailbox on O365 and enables E3 licence 
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$User
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain
)

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1
    }
} else {
    Write-Host "Domain should be AU or NZ"
    exit
}
Write-Host
Write-Host "Setup your Credentials for accessing the local exchange server" -ForegroundColor Cyan  
Write-Host $AdminAccount1

if ($stUserDomain -eq "au"){
    $EndAdmin = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $EndAdmin = "@edmi.co.nz"
} else {
    Write-Host "Your local account needs to be either AU or NZ" -ForegroundColor Red  
    exit
}

$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase + $End
# Write-Host "User eMail:  $Email"
Write-Host
Write-Host "Setup your Credentials for accessing the Office 365 systems" -ForegroundColor Cyan  
$Account = $stUserAccount + $EndAdmin
Write-Host $Account
if ($null -eq $O365CREDS){
    $O365CREDS   = Get-Credential $Account
} 
Write-Host
Write-Host "Connecting to Office 365" -ForegroundColor Green  
Connect-MSOLService -Credential $O365CREDS
If (Get-MsolUser -UserPrincipalName $Email -erroraction 'silentlycontinue') {
    Write-Host "User $Email Exits. Creating Mailbox on O365" -ForegroundColor Cyan  
} else {
    Write-Host "User $Email Doesn't Exist, wait till the user is on O365" -ForegroundColor Cyan  
    exit
}
Write-Host
Write-Host "Connecting to the Local Exchange Server" -ForegroundColor Green  
# Create user local AD, sync AD to O365 then when synced, run the following
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1 3>$null
$UserO365email = $UserLowerCase + "@edmi.mail.onmicrosoft.com"
Write-Host 
Write-Host "Setting up $UserLowerCase remote mailbox" -ForegroundColor Green  
Enable-RemoteMailbox -Identity $UserLowerCase  -DomainController $DomainController -RemoteRoutingAddress $UserO365email
Exit-PSSession
Remove-PSSession $Session1

# Write-Host "------------------------------------------------------------------------------------------------"
# Write-Host "Waiting a couple minutes for O365 email account to be created before enabling E3 licence." -ForegroundColor Cyan  
# Write-Host "Not sure if this is needed, or if we have to wait for the mailbox to sync back down to local AD." -ForegroundColor Cyan  
# Write-Host "This just seems to work" -ForegroundColor Cyan  
# Write-Host "------------------------------------------------------------------------------------------------"
# Start-Sleep -s 15
# Write-Host "----- 0:15"
# Start-Sleep -s 15
# Write-Host "----- 0:30"
# Start-Sleep -s 15
# Write-Host "----- 0:45"
# Start-Sleep -s 15
# Write-Host "----- 1:00"
# Start-Sleep -s 15
# Write-Host "----- 1:15"
# Start-Sleep -s 15
# Write-Host "----- 1:30"
# Start-Sleep -s 15
# Write-Host "----- 1:45"
# Start-Sleep -s 15
# Write-Host "----- 2:00"
# Start-Sleep -s 15
# Write-Host "----- 2:15"
# Start-Sleep -s 15
# Write-Host "----- 2:30"
# Start-Sleep -s 15
# Write-Host "----- 2:45"
# Start-Sleep -s 15
# Write-Host "----- 3:00"
# Start-Sleep -s 15
# Write-Host "----- 3:15"
# Start-Sleep -s 15
# Write-Host "----- 3:30"
# Start-Sleep -s 15
# Write-Host "----- 3:45"
# Start-Sleep -s 15
# Write-Host "----- 4:00"

# # Give E3 licence to user
# Connect-MSOLService -Credential $O365CREDS
# Get-ADUser $UserLowerCase | Set-MsolUser  -UsageLocation $Domain                   # Sets the location (Country) of the user
# Set-MsolUserLicense -UserPrincipalName $Email -AddLicenses "EDMI:ENTERPRISEPACK"   # Gives E3 licence

# SIG # Begin signature block
# MIITzAYJKoZIhvcNAQcCoIITvTCCE7kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFmlROkdjSTUFiAGPjQqOBci5
# q4mgghEqMIIEVjCCAz6gAwIBAgIKJjdc9gABAAAACTANBgkqhkiG9w0BAQsFADAe
# MRwwGgYDVQQDExNFRE1JIEdsb2JhbCBSb290IENBMB4XDTE2MTAyMDAzMDMwOVoX
# DTI2MTAyMDAzMTIwMlowRjEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZIm
# iZPyLGQBGRYEZWRtaTEXMBUGA1UEAxMORURNSSBHbG9iYWwgQ0EwggEiMA0GCSqG
# SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxKFzVMCqwmEw3OIqQf6VUwr3k5MZ0XucN
# FKLfVkahyUztXIhQwwNsnW+HjclzgDTewY/2qtXobECA4H+wibB0c6roSuUx3ZU5
# wXd7E5fjWGmFw7Oh4vk4LAwckWeeMXvQ1qPZSExQlV5+EU+VMhk4w/d87Z2afZ+9
# tFBnt6WApmzRXB/rMAyUlOOI7I9Bycd9BbfBEDYSy61tjMfnzY61a93WIm1oABSk
# 3W5U3KAhaoZrK5e077+dK7AhPYELxpC+qSzSsu0wYXuCTahE+dScRa5jxcCpRfuZ
# KfS/H001cPHBG3+cExrD5hV8scKf6LP6VVnt6NGihp8VnwGEgM6TAgMBAAGjggFs
# MIIBaDASBgkrBgEEAYI3FQEEBQIDAgACMCMGCSsGAQQBgjcVAgQWBBS6fmJZtj8/
# qU+H54dqRMC/EJlOOTAdBgNVHQ4EFgQUOl46QWE+W8BE0z8nl7VwNJwa2SQwGQYJ
# KwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQF
# MAMBAf8wHwYDVR0jBBgwFoAUfprvQO8VTOW2HfMHBTHdUVvgMBcwTgYDVR0fBEcw
# RTBDoEGgP4Y9aHR0cDovL2VkbWlibmVjYTIvQ2VydEVucm9sbC9FRE1JJTIwR2xv
# YmFsJTIwUm9vdCUyMENBKDEpLmNybDBkBggrBgEFBQcBAQRYMFYwVAYIKwYBBQUH
# MAKGSGh0dHA6Ly9lZG1pYm5lY2EyL0NlcnRFbnJvbGwvRWRtaUJuZUNhMV9FRE1J
# JTIwR2xvYmFsJTIwUm9vdCUyMENBKDEpLmNydDANBgkqhkiG9w0BAQsFAAOCAQEA
# NfPi4ztI4jZ+MmGSC3kA7djlqyhgwcLqHRway2VcV3UmQjJ0sdbuK6mTrJlFsXv4
# JQmp27f0PEksHR8wyLZ7x1EM6N2EREZ7mbArOiuHiRa7UwNBFFwexRigIaugfcNb
# y28rm0st6rOEjV5nYE6sxuK0XUG13a+bBHBMZW/U2dgx4xkfyloXn69xNbrvsLeP
# YlijjN+JzqSBfVMe7JD54bCsG9J4sDimvBOHbp5mTzKnnVbqZEuGuyCPNRiB/oWM
# LtmR/0pdK8FOEJDFW521MkGODrJloGf9xNLGMC7nkWLUbprD91gLVUwMb70mg8Yt
# 1yMSxilRQFGK/Yl7MCiGADCCBckwggSxoAMCAQICCiZqAPMAAgAAAJAwDQYJKoZI
# hvcNAQELBQAwRjEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZImiZPyLGQB
# GRYEZWRtaTEXMBUGA1UEAxMORURNSSBHbG9iYWwgQ0EwHhcNMTgxMDE4MDQwMzM2
# WhcNMjAxMDE4MDQxMzM2WjBdMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFDASBgoJ
# kiaJk/IsZAEZFgRlZG1pMRIwEAYKCZImiZPyLGQBGRYCYXUxGjAYBgNVBAMTEUVE
# TUkgQXVzdHJhbGlhIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# yNNMtmVcvPY6LoD/IJWZWRjaxI6JlhPqBNJMnMj9j4jiQaxm4imIe2MOcY0DbwAv
# AjadRgejwYDiEBMUbnwvWoLz7wRln073esPV5Mh18phiolD9vg29+vRPiarfJp36
# 4uD/Bhg9fASSQhNv7a+zJ+HgIGFsfdyF6VXnH+SRbTkLUsq031wo+E6FREVnQl1h
# 9oSafMWzP2gP94qRJHVgS716shAEV7VfhIq/EJkBXNJsMa/ofn5nddAf8DXLr5zq
# MLukAzl9CagHUODUlHzKHr4gZJyUxuXTukOjHCQdz2QBmMuq7bkRve8Qtx8b7RNN
# LD0IDf3Jlhk/Nn+0i05ZCwIDAQABo4ICoDCCApwwEgYJKwYBBAGCNxUBBAUCAwcA
# BzAjBgkrBgEEAYI3FQIEFgQUgqN+VVWyeitcIdezHBrw0aICQ00wHQYDVR0OBBYE
# FA0Sro/h/iMgoD3AujZxJxwVU2QhMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBB
# MA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFDpe
# OkFhPlvARNM/J5e1cDScGtkkMIIBHQYDVR0fBIIBFDCCARAwggEMoIIBCKCCAQSG
# gb5sZGFwOi8vL0NOPUVETUklMjBHbG9iYWwlMjBDQSgyKSxDTj1FZG1pQm5lQ2Ey
# LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxD
# Tj1Db25maWd1cmF0aW9uLERDPWVkbWksREM9bG9jYWw/Y2VydGlmaWNhdGVSZXZv
# Y2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50
# hkFodHRwOi8vZWRtaWJuZWNhMi5lZG1pLmxvY2FsL0NlcnRFbnJvbGwvRURNSSUy
# MEdsb2JhbCUyMENBKDIpLmNybDCBwwYIKwYBBQUHAQEEgbYwgbMwgbAGCCsGAQUF
# BzAChoGjbGRhcDovLy9DTj1FRE1JJTIwR2xvYmFsJTIwQ0EsQ049QUlBLENOPVB1
# YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
# b24sREM9ZWRtaSxEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xh
# c3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTANBgkqhkiG9w0BAQsFAAOCAQEAPiH9
# Z22TppVqMbMF3xI7VZiCwslS1kvw3KoBJ4QYnYQlzaIuA/UCdm25zatxlkAJVXeq
# ZusrDfFovQXKFr0zp+ELIgGlWBIAeWcc6qR5steCxn8T+ydDSDH39apShdrdMbM9
# k+SCQxAXzEXo+5n9Pmh5mWxFEkN/uBE13ZqSTWq+YgzouRMDgQ+GXvWT4+eljS3P
# LU2gxnHGZcT3T33S1gJ+/nKYdBrp0S56/S4NRT3mWQYL5OZ6MRM+yYe9a4cXZOm3
# BcMYWLExUyJz8MxinX39Y22drvtu5XXL7vZANFnDD/jihLd9koqDS8e24om5OFIJ
# R5matxGYZbRMUDQmQTCCBv8wggXnoAMCAQICCkj1kl8ABwAAU38wDQYJKoZIhvcN
# AQELBQAwXTEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZImiZPyLGQBGRYE
# ZWRtaTESMBAGCgmSJomT8ixkARkWAmF1MRowGAYDVQQDExFFRE1JIEF1c3RyYWxp
# YSBDQTAeFw0xOTEwMDMwMzE1MThaFw0yMDEwMDIwMzE1MThaMIHFMRUwEwYKCZIm
# iZPyLGQBGRYFbG9jYWwxFDASBgoJkiaJk/IsZAEZFgRlZG1pMRIwEAYKCZImiZPy
# LGQBGRYCYXUxFzAVBgNVBAsTDkVETUkgQXVzdHJhbGlhMRIwEAYDVQQLEwlFbXBs
# b3llZXMxFDASBgNVBAsTC0JyaXNiYW5lIEhRMRkwFwYDVQQLExBCdXNpbmVzcyBT
# eXN0ZW1zMQ0wCwYDVQQLEwRUZXN0MRUwEwYDVQQDEwxQZXRlciBMb3V2ZWwwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDJYdqwVBSpud/sYG7eZapLpeoh
# PP9TVPuirIt+OtXpW4Qm4Qp95r/bEFUBiVTU4EGwSe0plhqgkpWWqjrR3ftVrK6a
# AYkuPsXEyTeRoLmohOHpeMuBiq+0BY3+skzwtc/VJVzaTiNVaTi9w8NLsgum/kgJ
# eh9uWXAuu/RSlHFBxAUxAAT4kZfcmWWb4Ff+5zGKcITJNIDnBkTeAGqSz7p8pp/y
# aQFAJwy/VOSwGrSiLd3Op/Xw3rwa1+A8OVLl8DJsfC+JIZllZowKeKUDS0wO/oLS
# xli4sU0O0FP68p0fRqsIwzq3Z4R/7mxrbpnREpLiEmyanB4z97VfHnyo+WvpAgMB
# AAGjggNWMIIDUjA9BgkrBgEEAYI3FQcEMDAuBiYrBgEEAYI3FQiHt4wonIQfhaGb
# F4SRo3yGzulvgTyG9bBAhoyySwIBZQIBBjATBgNVHSUEDDAKBggrBgEFBQcDAzAO
# BgNVHQ8BAf8EBAMCB4AwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAzBgNV
# HREELDAqoCgGCisGAQQBgjcUAgOgGgwYcGV0ZXIubG91dmVsQGVkbWkuY29tLmF1
# MB0GA1UdDgQWBBRytQT/aCG4GvJyTDRpkk3MgOFJWzAfBgNVHSMEGDAWgBQNEq6P
# 4f4jIKA9wLo2cSccFVNkITCCASIGA1UdHwSCARkwggEVMIIBEaCCAQ2gggEJhoG/
# bGRhcDovLy9DTj1FRE1JJTIwQXVzdHJhbGlhJTIwQ0EoNyksQ049QXVCbmVDYTEs
# Q049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENO
# PUNvbmZpZ3VyYXRpb24sREM9ZWRtaSxEQz1sb2NhbD9jZXJ0aWZpY2F0ZVJldm9j
# YXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSG
# RWh0dHA6Ly9hdWJuZWNhMS5hdS5lZG1pLmxvY2FsL0NlcnRFbnJvbGwvRURNSSUy
# MEF1c3RyYWxpYSUyMENBKDcpLmNybDCCATIGCCsGAQUFBwEBBIIBJDCCASAwgbMG
# CCsGAQUFBzAChoGmbGRhcDovLy9DTj1FRE1JJTIwQXVzdHJhbGlhJTIwQ0EsQ049
# QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
# bmZpZ3VyYXRpb24sREM9ZWRtaSxEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/
# b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTBoBggrBgEFBQcwAoZc
# aHR0cDovL2F1Ym5lY2ExLmF1LmVkbWkubG9jYWwvQ2VydEVucm9sbC9BdUJuZUNh
# MS5hdS5lZG1pLmxvY2FsX0VETUklMjBBdXN0cmFsaWElMjBDQSg3KS5jcnQwDQYJ
# KoZIhvcNAQELBQADggEBAJDfa8rvsUPxNj2EokwSuS9Lq9Qm4u65BzatRNbbi3Wl
# IPgbTp0xfQAVYteM4ke/9r+rStd3clIF+PPn/R7QyzB4kKQGMQ5MM5i+QU/0gA/7
# sUds1+4KJSqrr6v9qv/cyjZMjzbQJ0TxMGND1G2TyqS1No/Y8yg/UsndbwHbbFa7
# V+IV50Z8luJP4FdiVT3QifuZ2Oub/WP6ELyglHk0jhPUOgJviP0q9TmCzgb58gs/
# OSZ4UYzM4SnSQ2NwBSvyc/aT735VC8nmBZSe63ZkiVImpg3XBSQ9Aj0qiYolkFdL
# 427a2NwriZIZa8YzV09zMFqhkBMW6Wea2BZqzm0Zt/8xggIMMIICCAIBATBrMF0x
# FTATBgoJkiaJk/IsZAEZFgVsb2NhbDEUMBIGCgmSJomT8ixkARkWBGVkbWkxEjAQ
# BgoJkiaJk/IsZAEZFgJhdTEaMBgGA1UEAxMRRURNSSBBdXN0cmFsaWEgQ0ECCkj1
# kl8ABwAAU38wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAw
# GQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
# AQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFOlo3PBPJeW5LBNoFItLN27QJcuUMA0G
# CSqGSIb3DQEBAQUABIIBABqsZtoPrIS6vHZNHvQBk+5lVBSCsxd9qCBlF6urauYM
# qHPnTeNyVbh6uKmIExjDWPQS3pqIO+gmRLdPNDB+JpPDxGteRn0U6r8gOSoEq1aW
# EKIjsvPsHLKt4P+oJHO/yId5MhpUddt4DvQX8ItF8oDXyA4qr1qPC3L7dwVsrcHH
# O6BcXCqgOFUBrG4Uxn75kjjaNC2ORNoUbzu7DSwXoVBvxm1UzsaAprDn9jQTzTzu
# iN9aqlDk8XpqLYMg9/bc5qIk72Y0WrYzcxlyyzG/O0e2iOzlXVajR8qKqNmEYBCh
# KqNBRrZlm6m8gJceDxlmWWtc5yTHHc5iuTldMIK+gv8=
# SIG # End signature block
