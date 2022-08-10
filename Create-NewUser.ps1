<#
.SYNOPSIS
    Create a new User and copy other users groups and info
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Create-NewUser -UserName "FirstName LastName" -FromUser "existing.user" -Title "New Users Job Title" -UsersDomain "au"
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
    [string]$UserName
    ,[Parameter(Mandatory=$true)]
    [string]$FromUser
    ,[Parameter(Mandatory=$true)]
    [string]$Title
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
)

$ServerAU = "AuBneDC12.au.edmi.local"
$ServerNZ = "NzBneDC5.nz.edmi.local"
#  "NZwlgDC3.nz.edmi.local"
$ServerSG = "SgBneDC1.sg.edmi.local"
$ServerUK = "UkBneDC2.uk.edmi.local"
#  "UkRdgDC1.uk.edmi.local"
$ServerEDMI = "EdmiBneDC11.edmi.local"

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}



if ($UsersDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = $ServerAU
    $FQD = "au.edmi.local"
    if ($null -eq $CredAU) { $CredAU = Get-Credential "au\"$AdminAccount } 
    $AdminAccount1 = $CredAU
    $Location = "Australia"
} elseif ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = $ServerNZ
    $FQD = "nz.edmi.local"
    if ($null -eq $CredNZ) { $CredNZ = Get-Credential "nz\"$AdminAccount } 
    $AdminAccount1 = $CredNZ
    $Location = "New Zealand"
} elseif ($UsersDomain -eq "uk"){   
    $End = "@edmi-meters.com"
    $DomainController = $ServerUK
    $FQD = "uk.edmi.local"
    if ($null -eq $CredUK) { $CredUK = Get-Credential "uk\"$AdminAccount } 
    $AdminAccount1 = $CredUK
    $Location = "United Kingdom"
} elseif ($UsersDomain -eq "sg"){    
    $End = "@edmi-meters.com"
    $DomainController = $ServerSG
    $FQD = "sg.edmi.local"
    if ($null -eq $CredSG) { $CredSG = Get-Credential "sg\"$AdminAccount } 
    $AdminAccount1 = $CredSG
    $Location = "Singapore"
} else {
    Write-Host
    Write-Host "Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}

if ($null -eq $AdminAccount1){ $AdminAccount1 = Get-Credential $AdminAccount1 } 

$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'
# $UserEmail      = $UserAccount.ToLower() + $End
$SamAccount         = $UserAccount

$Params             = @("Department", 
                "Office", 
                "physicalDeliveryOfficeName", 
                "City", 
                "wWWHomePage", 
                "PostalCode", 
                "POBox", 
                "postOfficeBox", 
                "DistinguishedName",
                "StreetAddress",
                "State",
                "Country",
                "Company",
                "Manager",
                "MemberOf"
                # ,"co"
                    )

$CopyUserObject = Get-ADUser -Identity $FromUser -Properties $Params -Server $DomainController

function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

function Create-Password{
    $password = ""
    $password = Get-RandomCharacters -length 5 -characters 'abcdefghkmnprstuvwxyz'
    $password += Get-RandomCharacters -length 3 -characters 'ABCDEFGHKMNPRSTUVWXYZ'
    $password += Get-RandomCharacters -length 2 -characters '23456789'
    $password += Get-RandomCharacters -length 1 -characters '$()=?}][{#*'
    $password = Scramble-String $password   
    return $password 
}

function Copy-Groups{
    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$NewAccountObject
        ,
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$CopyAccountObject
        # ,
        # [Parameter(Mandatory=$true)]
        # [PSCredential]$Credential
    )

    $counter = 0
    foreach ($UserGroup in $CopyAccountObject.MemberOf){ 
        $GroupName = ($UserGroup -split ",",2)[0]

        if ($UserGroup.Contains("DC=au")){
            Write-Host "AU  -- "$GroupName.Substring(3)
            $Server = $ServerAU
            if ($null -eq $CredAU) { $CredAU = Get-Credential "au\"$AdminAccount } 
            $AdminAccount1 = $CredAU
        }elseif ($UserGroup.Contains("DC=nz")){
            Write-Host "NZ  -- "$GroupName.Substring(3)
            $Server = $ServerNZ
            if ($null -eq $CredNZ) { $CredAU = Get-Credential "nz\"$AdminAccount } 
            $AdminAccount1 = $CredNZ
        }elseif ($UserGroup.Contains("DC=uk")){
            Write-Host "UK  -- "$GroupName.Substring(3)
            $Server = $ServerUK
            if ($null -eq $CredUK) { $CredUK = Get-Credential "uk\"$AdminAccount } 
            $AdminAccount1 = $CredUK
        }elseif ($UserGroup.Contains("DC=sg")){
            Write-Host "SG  -- "$GroupName.Substring(3)
            $Server = $ServerSG
            if ($null -eq $CredUK) { $CredSG = Get-Credential "sg\"$AdminAccount } 
            $AdminAccount1 = $CredSG
        }else{
            Write-Host "ROOT  -- "$GroupName.Substring(3)
            $Server = $ServerEDMI
            if ($null -eq $CredEDMI) { $CredEDMI = Get-Credential "edmi\"$AdminAccount } 
            $AdminAccount1 = $CredEDMI
        }

        try{
            # Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $Credential
            Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $AdminAccount1
            Write-Host "-- [Worked] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Yellow 
            Write-Host "----------------------------------------------------"
        }catch{
            Write-Host "-- Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $AdminAccount1" -ForegroundColor Yellow
            Write-Host "-- [ERROR] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Cyan
            Write-Host "   $($Error[0])" -ForegroundColor Red
            Write-Host "----------------------------------------------------"
        }
        $counter++
    }
}

function Copy-User{
    param(
        [Parameter(Mandatory=$true)]
        [String]$SamAccount
        ,[Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$CopyAccountObject
        # ,[Parameter(Mandatory=$true)]
        # [PSCredential]$Credential
    )
    
    $UserOU             = ($CopyAccountObject.DistinguishedName -split ",",2)[1]
    $Email              = $SamAccount + "" + $End
    $FullNewUserName    = $SamAccount -replace '\.',' '
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
    # $co                 = $CopyAccountObject.co

    $paramsCreate       = @{  
        Instance            = "$CopyAccountObject" 
        Path                = "$UserOU"
        Name                = "$FullNewUserName"
        SamAccountName      = "$SamAccount"
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
        # co                  = "$co"
    }
    # Write-Host $paramsCreate.Path
    Write-Host
    Write-Host "Creating new user " -NoNewline 
    Write-Host "$FullNewUserName " -ForegroundColor Cyan -NoNewline 
    Write-Host "$SamAccount" -ForegroundColor Green

    Try{
        New-ADUser  @paramsCreate -Credential $AdminAccount1 -Server $DomainController  
    }Catch{
        Write-Host ""
        Write-Host "-- New-ADUser  @paramsCreate -Credential $AdminAccount1" -ForegroundColor Yellow 
        Write-Host "-- [ERROR] $DomainController - $($SamAccount) - $($Error[0])" -ForegroundColor Red 
        Write-Host "----------------------------------------------------"
    }
    Write-Host " --- give it 20 seconds to sync the AD Changes"
    Start-Sleep -s 20
    if ($manager){
        $managerName = $manager.Split(",").substring(3)[0]
        Write-Host "Setting users manager to " -ForegroundColor Green -NoNewline
        Write-Host "$managerName" -ForegroundColor Cyan
        Set-ADUser -Identity "$SamAccount" -Replace @{manager="$Manager"} -Credential $AdminAccount1 -Server $DomainController 
    }
    Write-Host "Setting users password to " -NoNewline  -ForegroundColor Cyan   
    Write-Host "$newPass" -ForegroundColor Green  
    Start-Sleep -s 5
    Set-ADAccountPassword -Identity "$SamAccount" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $AdminAccount1 -Server $DomainController
    Enable-ADAccount -Identity "$SamAccount" -Credential $AdminAccount1 -Server $DomainController
    Set-ADUser -ChangePasswordAtLogon $true -Identity "$SamAccount" -Credential $AdminAccount1 -Server $DomainController -Confirm:$false
}

$newPass = Create-Password

Copy-User -SamAccount $SamAccount -CopyAccountObject $CopyUserObject 
# -Credential $DomainAdminCred
Start-Sleep -s 5
Get-ADUser -Identity $SamAccount -Server $DomainController | Set-ADObject -Replace @{co="$Location"} -Credential $AdminAccount1 -Server $DomainController
Write-Host "-----------------------------------------------------------------------"
# can be qicker if staff is in your local domain, but longer when on the other domain
Write-Host "Waiting 120 seconds for AD systems to update before copying user groups." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 120

$NewUserObject = Get-ADUser -Identity $SamAccount -Properties $Params -Server $DomainController -Credential $AdminAccount1
# -Credential $DomainAdminCred
Write-Host "========================================================================"
Copy-Groups -NewAccountObject $NewUserObject -CopyAccountObject $CopyUserObject 
# -Credential $DomainAdminCred
Write-Host "$SamAccount   ---  $newPass" -ForegroundColor Green