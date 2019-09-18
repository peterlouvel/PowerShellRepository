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

if ($Domain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "NZwlgDC3.nz.edmi.local"
} else {
    exit
}

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")

$AdminAccount = $stUserAccount + "_"
# Write-Host $AdminAccount

if ($null -eq $Cred){
    $Cred = Get-Credential $AdminAccount
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
$CopyUserObject     = Get-ADUser -Identity "$CopyUser" -Properties $Params -Server $DomainController

function Set-HomeDirectory{
#     param(
#         [Parameter(Mandatory=$true)]
#         [Microsoft.ActiveDirectory.Management.ADObject]$AccountObject,
#         [Parameter(Mandatory=$true)]
#         [PSCredential]$Credential
#     )

#     $FileServerLocation = "fileserver.au.edmi.local"
#     $AccountName = $AccountObject.SamAccountName
#     $fullPath = "\\$FileServerLocation\Home\{0}" -f $AccountName
#     $driveLetter = "Z:"
#     $User = Get-ADUser -Identity $AccountName

#     if ($Null -ne $User){
#         Set-ADUser $User -HomeDrive $driveLetter -HomeDirectory $fullPath -ea Stop -Credential $Credential
#         try{
#             New-PSDrive -Name NewPSDrive -PSProvider FileSystem -Root \\$FileServerLocation\c$ -Credential $Credential
#             $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop 
#         }catch{
#             Write-Host "-- [ERROR] - $($Error[0])" -ForegroundColor Green 
#             exit
#         }
#         try{
#             $acl = Get-Acl $homeShare
#         }catch{
#             Write-Host "-- [ERROR] - $($Error[0])" -ForegroundColor Green 
#             exit
#         }
#         $FileSystemRights   = [System.Security.AccessControl.FileSystemRights]"Modify"
#         $AccessControlType  = [System.Security.AccessControl.AccessControlType]::Allow
#         $InheritanceFlags   = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
#         $PropagationFlags   = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
#         $AccessRule         = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
#         $acl.AddAccessRule($AccessRule)

#         Set-Acl -Path $homeShare -AclObject $acl -ea Stop 
#         Write-Host ("HomeDirectory created at {0}" -f $fullPath)
#     }
}
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
        Write-Host ($GroupName.Substring(3))
        # Write-Host $counter + " " + $UserGroup
        if ($UserGroup.Contains("DC=au")){
            $Server = "au.edmi.local"
        }elseif ($UserGroup.Contains("DC=nz")){
            $Server = "nz.edmi.local"
        }elseif ($UserGroup.Contains("DC=sg")){
            $Server = "sg.edmi.local"
            Continue
            # Don't have access to Singapore Domain
        }else{
            $Server = "edmi.local"
        }
        try{
            Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $cred
        }catch{
            Write-Host "----------------------------------------------------"
            Write-Host "-- Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $cred" -ForegroundColor Yellow 
            Write-Host "-- [ERROR] $server - $($_.distinguishedName) - $($Error[0])" -ForegroundColor Green 
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
    $Email              = $NewUserAccount +"@edmi.com.au"
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
    Write-Host "Creating new user " -NoNewline 
    Write-Host "$FullNewUserName " -ForegroundColor Cyan -NoNewline 
    Write-Host "$NewUserAccount" -ForegroundColor Green
    Try{
        New-ADUser  @paramsCreate -Credential $Credential -Server $DomainController  #"AuBneDC11.au.edmi.local:3268"
    }Catch{
        Write-Host ""
        Write-Host "-- New-ADUser  @paramsCreate -Credential $Credential" -ForegroundColor Yellow 
        Write-Host "-- [ERROR] $server - $($NewUserAccount) - $($Error[0])" -ForegroundColor Green 
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
function New-Mailbox{
    # param(
    #     [Parameter(Mandatory=$true)]
    #     [string]$User
    # )
    
    # $UserLowerCase = $User.ToLower()
    # $Email = $UserLowerCase +"@edmi.com.au"

    # if ($null -eq $Cred){
    #     $Cred   = Get-Credential "au\peter.louvel_"
    # } 

    # $Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
    # Import-PSSession $Session1 3>$null
    # Enable-Mailbox -Identity $UserLowerCase -Database "Mailbox Database Australian Users" -DomainController "$DomainController"
    # Exit-PSSession
    # Remove-PSSession $Session1
}

Copy-User -NewUserAccount "$NewUser" -CopyAccountObject "$CopyUserObject" -Credential "$Cred"
Write-Host "-----------------------------------------------------------------------"
Write-Host "Waiting 10 seconds for AD systems to update before copying user groups." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 10

# use separate  Enable-O365Email.ps1  script to create email on O365
# *****  New-Mailbox $NewUser  *****

$NewUserObject = Get-ADUser -Identity "$NewUser" -Properties $Params
Copy-Groups -NewAccountObject "$NewUserObject" -CopyAccountObject "$CopyUserObject" -Credential "$Cred"

# No need for home directories anymore.
# *****  Set-HomeDirectory -AccountObject $NewUserObject -Credential $Cred  *****
