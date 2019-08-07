# $Cred = Get-Credential peterl_

$NewUser            = "Test.uSer01"
$CopyUser           = "BrendonV"
$Title              = "Software Developer (Contractor)"
$newPass            = ""

$Params = @("Department", 
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
)

$CopyUserObject     = Get-ADUser -Identity $CopyUser -Properties $Params
$UserOU             = ($CopyUserObject.DistinguishedName -split ",",2)[1]
$UserLowerCase      = $NewUser.ToLower()
$NewUser            = (Get-Culture).TextInfo.ToTitleCase($UserLowerCase) 
$Email              = $UserLowerCase +"@edmi.com.au"
$FullNewUserName    = $NewUser -replace '\.',' '
$Pos                = $FullNewUserName.IndexOf(" ")
$GivenName          = $FullNewUserName.Substring(0, $Pos)
$Surname            = $FullNewUserName.Substring($Pos+1)
$Department         = $CopyUserObject.Department
$Office             = $CopyUserObject.Office
$City               = $CopyUserObject.City
$PostalCode         = $CopyUserObject.PostalCode
$POBox              = $CopyUserObject.POBox
$HomePage           = $CopyUserObject.wWWHomePage
$Address            = $CopyUserObject.StreetAddress
$State              = $CopyUserObject.State
$Country            = $CopyUserObject.Country
$Company            = $CopyUserObject.Company
$Manager            = $CopyUserObject.Manager
$HomeDirectory      = "\\fileserver.au.edmi.local\users\$UserLowerCase" 
$HomeDrive          = "Z";

function FuncCopyGroup{
    # FuncMessageOut "CopyGroup"
   
    $User  = $NewUser
    $UserCopyFrom = Get-ADUser -Identity $LblShow.Text -Properties *

    $counter = 0
    foreach ($UserGroup in $CopyUserObject.MemberOf) { 
        Write-Host $counter + " " + $UserGroup
        if ($UserGroup.Contains("DC=au")){
            $Server = "au.edmi.local"
        } elseif ($UserGroup.Contains("DC=nz")) {
            $Server = "nz.edmi.local"
        } else {
            $Server = "edmi.local"
         }
        FuncMessageOut "$server"
        
        try {
            Set-ADObject -Identity $UserGroup -Add @{"member"=$User.DistinguishedName} -Server $Server -Credential $cred
        } Catch {
            FuncErrorOut "Set-ADObject -Identity $UserGroup -Add @{"member"=$User.DistinguishedName} -Server $Server -Credential $cred"
            FuncErrorOut "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
        }
        $counter++
    }
}

function FuncCreateUser{
    $paramsCreate       = @{  
        Instance            = "$CopyUserObject" 
        Path                = "$UserOU"
        Name                = "$NewUser"
        SamAccountName      = "$UserLowerCase"
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
        HomeDirectory       = "$HomeDirectory"
        HomeDrive           = "$HomeDrive"
        Company             = "$Company"

        }

    New-ADUser  @paramsCreate -Credential $Cred # -Server "AuBneDC11.au.edmi.local:3268"
    Write-Host  New-ADUser @paramsCreate -Credential $Cred 
    Start-Sleep -s 3
    Set-ADUser -Identity "$UserLowerCase" -Replace @{manager="$Manager"} -Credential $Cred 
    Write-Host  Set-ADUser -Identity "$UserLowerCase" -Replace @{manager="$Manager"} -Credential $Cred 
    Start-Sleep -s 10
    Set-ADAccountPassword -Identity "$UserLowerCase" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $Cred 
    Write-Host  Set-ADAccountPassword -Identity "$UserLowerCase" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $Cred 
    Enable-ADAccount -Identity "$UserLowerCase" -Credential $Cred 
    Write-Host  Enable-ADAccount -Identity "$UserLowerCase" -Credential $Cred 
}

FuncCreateUser
