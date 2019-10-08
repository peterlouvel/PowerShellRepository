<#
.SYNOPSIS
    
.DESCRIPTION
    
.EXAMPLE
    PS C:\> MoveLicence
   
.INPUTS
    .
.OUTPUTS
    .
.NOTES
    Domain can be
        au
        nz

        EDMI Pty Ltd, Scott Walker , 74430ce8-49b7-4f72-8b54-1c334958bf25
 
        Subscription Id	                                                                Product Name	            Start Date	End Date
        4D4ECDEA-4CD4-4C10-9BF1-198C855B80C4	f8a1db68-be16-40ed-86d5-cb42ce701560    Power BI Pro	            30/09/2019	26/10/2020
        C1EBFD10-C1D0-4299-BB17-DFCCB4ED3176    c5928f49-12ba-48f7-ada3-0d743a3601d5    Visio Online Plan 2	        30/09/2019	26/10/2020
        1EC5CFAD-301F-4E1D-BE20-2C866C620368	18181a46-0d4e-45cd-891e-60aabd171b4e    Office 365 E1	            30/09/2019	26/10/2020
        0509C8EA-3871-4B6F-8DF8-5D5F8C79850B	6fd2c87f-b296-42f0-b197-1e91e994b900    Office 365 E3	            30/09/2019	26/10/2020
        59B7E94D-3C77-41A2-8E6C-6CAF894C83FD	4b9405b0-7788-4568-add1-99614e613b69    Exchange Online (Plan 1)	30/09/2019	26/10/2020
#>


[String] ${stUserDomain}, [String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")

# Write-Host $stUserDomain
# Write-Host $stUserAccount

# Setup correct ending for UPN
if ($stUserDomain -eq "au"){
    $End = "@edmi.com.au"
} elseif ($stUserDomain -eq "nz"){
    $End = "@edmi.co.nz"
} else {
    Write-Host "Run this command with your AU or NZ Domain credentials that can access Office 365"
    exit
}

#if $O365CREDS not setup before script run, setup now
if ($null -eq $O365CREDS){
    $Account = $stUserAccount + $End
    # Write-Host $Account
    $O365CREDS   = Get-Credential $Account
} 

Install-Module -Name AzureAD -Scope CurrentUser
Connect-AzureAD -Credential $O365CREDS
Connect-MsolService -Credential $O365CREDS



$licensePlanList = Get-AzureADSubscribedSku
# Write-Host $licensePlanList

$subscriptionFrom="ENTERPRISEPACK"
$subscriptionTo=  "ENTERPRISEPACK"

$Users = Get-MsolUser -All | Where-Object -Property isLicensed
foreach ($User in $Users){
    Write-Host "------------------------------"
    $userUPN=$User.UserprincipalName
    Write-Host $userUPN

    $userList = Get-AzureADUser -ObjectID $userUPN | Select -ExpandProperty AssignedLicenses | Select SkuID 
    Write-host $userList
    $userList | ForEach { 
        $sku=$_.SkuId ; $licensePlanList | ForEach { 
            If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) { 
                Write-Host $_.SkuPartNumber 
            } 
        } 
    }

}

<#
$userUPN = "peter.louvel@edmi.com.au"

$licenseFrom = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licensesFrom = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$licenseTo = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licensesTo = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

#Adds Current licence
$licenseFrom.SkuId = "6fd2c87f-b296-42f0-b197-1e91e994b900"
$licensesFrom.AddLicenses = $licenseFrom
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesFrom

#Removes that licence
$licensesFrom.AddLicenses = @()
$licensesFrom.RemoveLicenses =  $licenseFrom.SkuId
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesFrom

# Assign new licence
$licenseTo.SkuId = "796b6b5f-613c-4e24-a17c-eba730d49c02"
$licensesTo.AddLicenses = $LicenseTo
Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licensesTo

#>

<#      in vscode 
    ##    
        $Mycert = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0]
        $currentFile = $psEditor.GetEditorContext().CurrentFile.Path
        Set-AuthenticodeSignature -Certificate $Mycert -FilePath $currentFile
    
    ##  
        Set-AuthenticodeSignature -FilePath ${activeFile} -Certificate @(Get-ChildItem cert:\\CurrentUser\\My -codesign)[0]
        Set-AuthenticodeSignature -FilePath $psEditor.GetEditorContext().CurrentFile.Path -Certificate @(Get-ChildItem cert:\\CurrentUser\\My -codesign)[0]
#>

# SIG # Begin signature block
# MIITzAYJKoZIhvcNAQcCoIITvTCCE7kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPEUyj+XnBEYJ8lOO+0rpyNtd
# mJmgghEqMIIEVjCCAz6gAwIBAgIKJjdc9gABAAAACTANBgkqhkiG9w0BAQsFADAe
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
# AQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLSbabkJ5CJBDXPc79Nrz8nOiXUfMA0G
# CSqGSIb3DQEBAQUABIIBAIeKYGFusDWuQWlg0Wo3QHgWzIeDBYeQDnWA3APASabF
# a0nwv77DuIUOrM2zD8SVIj8vZMcCfn6eUB6yv07beEaGKP4T2RkW/Ly94acBF5GW
# RPOu/myerphTi29yw9oMTiipGDsyVldscP+Lc5MyHDc3R3hH9fUNi8FsLM1ccdQG
# q93lF6KqC0/c7qIzl2WOAoYKPxn68e1+RoKl/aYmOxw9dFNVvpyu3h7dbImCWOdD
# fni+fKUxT8wuj6RaxXUVjS/Hp9IpSNy9/XhLHJZNkSb0UDZ3rJt/Ig7F6KKWxxvo
# BvqgATmTTOSaEIdnEUbxGCokyXSyayd9djwd8FzITX4=
# SIG # End signature block
