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
    $Server = "au.edmi.local"
} elseif ($Domain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "NZwlgDC3.nz.edmi.local"
    $Server = "nz.edmi.local"
} else {
    exit
}

[String] ${stUserDomain},[String]  ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stUserAccount + "_"

if ($null -eq $Cred){
    $Cred = Get-Credential $AdminAccount
    # $Cred = Get-Credential "nz\peterl_"
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
    Write-Host $paramsCreate.Path
    Write-Host "Creating new user " -NoNewline 
    Write-Host "$FullNewUserName " -ForegroundColor Cyan -NoNewline 
    Write-Host "$NewUserAccount" -ForegroundColor Green

    Try{
        New-ADUser  @paramsCreate -Credential $Credential -Server $DomainController  
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


Write-Host $Server
Copy-User -NewUserAccount $NewUser -CopyAccountObject $CopyUserObject -Credential $Cred
Write-Host "-----------------------------------------------------------------------"
Write-Host "Waiting 120 seconds for AD systems to update before copying user groups." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 120

$NewUserObject = Get-ADUser -Identity $NewUser -Properties $Params -Server $DomainController -Credential $Cred
Write-Host "========================================================================"
Copy-Groups -NewAccountObject $NewUserObject -CopyAccountObject $CopyUserObject -Credential $Cred
