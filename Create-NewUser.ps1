<#
.SYNOPSIS
    Create a new User and copy other users groups and info
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Create-NewUser -NewAccount "new.user" -CopyUser "existing.user" -Title "New Users Job Title" -Domain "au"
    Creates user "new.user and copies some info from "existing.user" 
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
    [string]$NewAccount
    ,
    [Parameter(Mandatory=$true)]
    [string]$CopyUser
    ,
    [Parameter(Mandatory=$true)]
    [string]$Title
    ,
    [Parameter(Mandatory=$true)]
    [string]$Domain
)

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $Server = "au.edmi.local"
    if ($null -eq $Cred){
        $AdminAccount1 = "au\"+$AdminAccount
        $Cred = Get-Credential $AdminAccount1
    } 
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $Server = "nz.edmi.local"
    if ($null -eq $Cred){
        $AdminAccount1 = "nz\"+$AdminAccount
        $Cred = Get-Credential $AdminAccount1
    }
} else {
    Write-Host "Domain should be AU or NZ"
    exit
}



$UserLowerCase      = $NewAccount.ToLower()
$NewUser            = (Get-Culture).TextInfo.ToTitleCase($UserLowerCase) 
$Params             = @("Department", 
                "Office", 
                "physicalDeliveryOfficeName", 
                "City", 
                "wWWHomePage", 
                "PostalCode", 
                "POBox", 
                "postOfficeBox", 
                "DistinguishedName"
                "StreetAddress"
                "State"
                "Country"
                "Company"
                "Manager"
                "MemberOf"
                    )
$CopyUserObject     = Get-ADUser -Identity $CopyUser -Properties $Params -Server $DomainController

function Copy-Groups{
    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$NewAccountObject
        ,
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$CopyAccountObject
        ,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Credential
    )

    $counter = 0
    foreach ($UserGroup in $CopyAccountObject.MemberOf){ 
        $GroupName = ($UserGroup -split ",",2)[0]
        # Write-Host $GroupName.Substring(3)

        # Write-Host $counter + " " + $UserGroup

        if ($UserGroup.Contains("DC=au")){
            Write-Host "AU  -- "$GroupName.Substring(3)
            $DomainController = "AuBneDC11.au.edmi.local"
            $Server = "au.edmi.local"
        }elseif ($UserGroup.Contains("DC=nz")){
            Write-Host "NZ  -- "$GroupName.Substring(3)
            $DomainController = "NZwlgDC3.nz.edmi.local"
            $Server = "nz.edmi.local"
        }elseif ($UserGroup.Contains("DC=sg")){
            Write-Host "SG  -- "$GroupName.Substring(3)
            Continue
            # Don't have access to Singapore Domain
        }else{
            Write-Host "ROOT  -- "$GroupName.Substring(3)
            $DomainController = "EdmiBneDC1.edmi.local"
            $Server = "edmi.local"
        }
        
        try{
            Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $Credential
            Write-Host "-- [Worked] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Yellow 
            Write-Host "----------------------------------------------------"
        }catch{
            Write-Host "-- Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $Credential" -ForegroundColor Yellow            
            Write-Host "-- [ERROR] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Yellow 
            Write-Host "   $($Error[0])" -ForegroundColor Red 
            Write-Host "----------------------------------------------------"
        }
        $counter++
    }
}
function Copy-User{
    param(
        [Parameter(Mandatory=$true)]
        [String]$NewUserAccount,
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$CopyAccountObject,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Credential
    )
    
    $UserOU             = ($CopyAccountObject.DistinguishedName -split ",",2)[1]
    $Email              = $NewUserAccount + "" + $End
    $FullNewUserName    = $NewUserAccount -replace '\.',' '
    $Pos                = $FullNewUserName.IndexOf(" ")
    $GivenName          = $FullNewUserName.Substring(0, $Pos)
    $Surname            = $FullNewUserName.Substring($Pos+1)
    $Department         = $CopyAccountObject.Department
    $Office             = $CopyAccountObject.Office
    $City               = $CopyAccountObject.City
    $PostalCode         = $CopyAccountObject.PostalCode
    $POBox              = $CopyAccountObject.POBox
    $HomePage           = $CopyAccountObject.wWWHomePage
    $Address            = $CopyAccountObject.StreetAddress
    $State              = $CopyAccountObject.State
    $Country            = $CopyAccountObject.Country
    $Company            = $CopyAccountObject.Company
    $Manager            = $CopyAccountObject.Manager
    $newPass            = [System.Web.Security.Membership]::GeneratePassword(10,3)
    $paramsCreate       = @{  
        Instance            = "$CopyAccountObject" 
        Path                = "$UserOU"
        Name                = "$NewUserAccount"
        SamAccountName      = "$NewUserAccount"
        GivenName           = "$GivenName" 
        Surname             = "$Surname" 
        DisplayName         = "$FullNewUserName"
        UserPrincipalName   = "$Email"
        Department          = "$Department" 
        Office              = "$Office"
        City                = "$City"
        PostalCode          = "$PostalCode"
        POBox               = "$POBox"
        Title               = "$Title"
        HomePage            = "$HomePage"
        StreetAddress       = "$Address"
        State               = "$State"
        Country             = "$Country"
        Company             = "$Company"
    }
    Write-Host $paramsCreate.Path
    Write-Host "Creating new user " -NoNewline 
    Write-Host "$FullNewUserName " -ForegroundColor Cyan -NoNewline 
    Write-Host "$NewUserAccount" -ForegroundColor Green

    Try{
        New-ADUser  @paramsCreate -Credential $Credential -Server $DomainController  
    }Catch{
        Write-Host ""
        Write-Host "-- New-ADUser  @paramsCreate -Credential $Credential" -ForegroundColor Yellow 
        Write-Host "-- [ERROR] $DomainController - $($NewUserAccount) - $($Error[0])" -ForegroundColor Green 
        Write-Host "----------------------------------------------------"
    }
    Write-Host "Setting users manger to $Manager"
    Start-Sleep -s 3
    Set-ADUser -Identity "$NewUserAccount" -Replace @{manager="$Manager"} -Credential $Credential -Server $DomainController 
    Write-Host "Setting users password to " -NoNewline  -ForegroundColor Cyan   
    Write-Host "$newPass" -ForegroundColor Green  
    Start-Sleep -s 10
    Set-ADAccountPassword -Identity "$NewUserAccount" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $Credential -Server $DomainController
    Enable-ADAccount -Identity "$NewUserAccount" -Credential $Credential -Server $DomainController
}


Write-Host $Server
Copy-User -NewUserAccount $NewUser -CopyAccountObject $CopyUserObject -Credential $Cred
Write-Host "-----------------------------------------------------------------------"
# can be qicker if staff is in your local comain, but longer when on the other domain
Write-Host "Waiting 120 seconds for AD systems to update before copying user groups." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 120

$NewUserObject = Get-ADUser -Identity $NewUser -Properties $Params -Server $DomainController -Credential $Cred
Write-Host "========================================================================"
Copy-Groups -NewAccountObject $NewUserObject -CopyAccountObject $CopyUserObject -Credential $Cred

# SIG # Begin signature block
# MIITzAYJKoZIhvcNAQcCoIITvTCCE7kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGtx+LYd/2ABq7jlhNn5v+Dld
# SsGgghEqMIIEVjCCAz6gAwIBAgIKJjdc9gABAAAACTANBgkqhkiG9w0BAQsFADAe
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
# R5matxGYZbRMUDQmQTCCBv8wggXnoAMCAQICCkghaVMABwAAU34wDQYJKoZIhvcN
# AQELBQAwXTEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZImiZPyLGQBGRYE
# ZWRtaTESMBAGCgmSJomT8ixkARkWAmF1MRowGAYDVQQDExFFRE1JIEF1c3RyYWxp
# YSBDQTAeFw0xOTEwMDIyMzIzMzNaFw0yMDEwMDEyMzIzMzNaMIHFMRUwEwYKCZIm
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
# BgNVHQ8BAf8EBAMCB4AwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNV
# HQ4EFgQUcrUE/2ghuBryckw0aZJNzIDhSVswHwYDVR0jBBgwFoAUDRKuj+H+IyCg
# PcC6NnEnHBVTZCEwggEiBgNVHR8EggEZMIIBFTCCARGgggENoIIBCYaBv2xkYXA6
# Ly8vQ049RURNSSUyMEF1c3RyYWxpYSUyMENBKDcpLENOPUF1Qm5lQ2ExLENOPUNE
# UCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25m
# aWd1cmF0aW9uLERDPWVkbWksREM9bG9jYWw/Y2VydGlmaWNhdGVSZXZvY2F0aW9u
# TGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hkVodHRw
# Oi8vYXVibmVjYTEuYXUuZWRtaS5sb2NhbC9DZXJ0RW5yb2xsL0VETUklMjBBdXN0
# cmFsaWElMjBDQSg3KS5jcmwwggEyBggrBgEFBQcBAQSCASQwggEgMIGzBggrBgEF
# BQcwAoaBpmxkYXA6Ly8vQ049RURNSSUyMEF1c3RyYWxpYSUyMENBLENOPUFJQSxD
# Tj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1
# cmF0aW9uLERDPWVkbWksREM9bG9jYWw/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVj
# dENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwaAYIKwYBBQUHMAKGXGh0dHA6
# Ly9hdWJuZWNhMS5hdS5lZG1pLmxvY2FsL0NlcnRFbnJvbGwvQXVCbmVDYTEuYXUu
# ZWRtaS5sb2NhbF9FRE1JJTIwQXVzdHJhbGlhJTIwQ0EoNykuY3J0MDMGA1UdEQQs
# MCqgKAYKKwYBBAGCNxQCA6AaDBhwZXRlci5sb3V2ZWxAZWRtaS5jb20uYXUwDQYJ
# KoZIhvcNAQELBQADggEBAIBdtirg3mAy2d2D8O+zms5WNgxGaeS844w/qFF12feK
# ZuO1pf0NDQhvBZhXP8wo8OYEEGQEWFBGPfZKvWfpr67C6Vc0wzT1bM6yOI/ddcft
# iDAo9EcUz54bkjXH9Ko+ptiKPk+vrBXAZnd4I+AcaY8Z00t1lVRMqSU+BFAU98t7
# j/ZeqHyIAU5PC7DAFejbbpIJmYT8OIZiDYdC80s33x8kWqaFQI1PgGgV4V645it3
# MZPq7s+3uo6aaZvBk7J3yJjQZfNuElejmtfwfw5YOG2XvxouiKi24pYW4xiff+hr
# v09FFmqBpP1iaayIsIXyKytOwYzFTb4yfk2TFKz+ZCoxggIMMIICCAIBATBrMF0x
# FTATBgoJkiaJk/IsZAEZFgVsb2NhbDEUMBIGCgmSJomT8ixkARkWBGVkbWkxEjAQ
# BgoJkiaJk/IsZAEZFgJhdTEaMBgGA1UEAxMRRURNSSBBdXN0cmFsaWEgQ0ECCkgh
# aVMABwAAU34wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAw
# GQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
# AQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFDbT5swH94Ewd1vzTLFx2+wQl47aMA0G
# CSqGSIb3DQEBAQUABIIBAKTxlLBij8DnuoSUbHwjWofFIDlJQubFzVTl/tN9GUWQ
# xyq57WH0QKYL/7WuSzN48HaEG2rhtwCz2TX0JBLQcP45rk6Rl79GFyfqhoMCuRH0
# 1U9WjRFG2+LLMqSmrW/ThdaBs8NvT1iwphAw3lGa2DIy73kaxwdwLhZ/pREFGImH
# JyEZGKbh+vi5FvLimE4Tvu9VzA5KMZumeJK2oRgFHsHTYCxyFaBFvgyIdGsftz1V
# eqocnKJ1353zaJYPU1hh6UHVVkZQx3MoT9WSaUIHNh4XEc5ho9F+1+lERWlElYrN
# fqjmqiS9cuoDzmwSTE6svNfU4n1UK+Ml/o/3w8Q/nN4=
# SIG # End signature block
