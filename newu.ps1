




if ($null -eq $Cred){
    $Cred   = Get-Credential peterl_
} 

$NewAccount = "Test.uSer01"
$CopyUser   = "BrendonV"
$Title      = "Software Developer (Contractor)"


$UserLowerCase      = $NewAccount.ToLower()
$NewUser            = (Get-Culture).TextInfo.ToTitleCase($UserLowerCase) 

$Params     = @("Department", 
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
$FileServerLocation = "fileserver.au.edmi.local"

$CopyUserObject = Get-ADUser -Identity $CopyUser -Properties $Params
function Set-HomeDirectory{
    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$AccountObject,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Credential
    )
    $AccountName = $AccountObject.SamAccountName
    $fullPath = "\\$FileServerLocation\Home\{0}" -f $AccountName
    $driveLetter = "Z:"
    $User = Get-ADUser -Identity $AccountName

    if ($Null -ne $User){
        Set-ADUser $User -HomeDrive $driveLetter -HomeDirectory $fullPath -ea Stop -Credential $Credential
        try{
            New-PSDrive -Name NewPSDrive -PSProvider FileSystem -Root \\$FileServerLocation\c$ -Credential $Credential
            $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop 
        }catch{
            Write-Host "-- [ERROR] - $($Error[0])" -ForegroundColor Green 
            exit
        }
        try{
            $acl = Get-Acl $homeShare
        }catch{
            Write-Host "-- [ERROR] - $($Error[0])" -ForegroundColor Green 
            exit
        }
        $FileSystemRights   = [System.Security.AccessControl.FileSystemRights]"Modify"
        $AccessControlType  = [System.Security.AccessControl.AccessControlType]::Allow
        $InheritanceFlags   = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
        $PropagationFlags   = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
        $AccessRule         = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
        $acl.AddAccessRule($AccessRule)

        Set-Acl -Path $homeShare -AclObject $acl -ea Stop 
        Write-Host ("HomeDirectory created at {0}" -f $fullPath)
    }
}
function Copy-Groups{
    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$NewAccountObject,
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$CopyAccountObject,
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
        New-ADUser  @paramsCreate -Credential $Credential # -Server "AuBneDC11.au.edmi.local:3268"
    }Catch{
        Write-Host ""
        Write-Host "-- New-ADUser  @paramsCreate -Credential $Credential" -ForegroundColor Yellow 
        Write-Host "-- [ERROR] $server - $($NewUserAccount) - $($Error[0])" -ForegroundColor Green 
        Write-Host "----------------------------------------------------"
    }
    Write-Host "Setting users manger to $Manager"
    Start-Sleep -s 3
    Set-ADUser -Identity "$NewUserAccount" -Replace @{manager="$Manager"} -Credential $Credential 
    Write-Host "Setting users password to " -NoNewline  -ForegroundColor Cyan   
    Write-Host "$newPass" -ForegroundColor Green  
    Start-Sleep -s 10
    Set-ADAccountPassword -Identity "$NewUserAccount" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $Credential 
    Enable-ADAccount -Identity "$NewUserAccount" -Credential $Credential 
}

Copy-User -NewUserAccount $NewUser -CopyAccountObject $CopyUserObject -Credential $Cred
Write-Host "Waiting 10 seconds for AD systems to update before copying user groups." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 10

$NewUserObject = Get-ADUser -Identity $NewUser -Properties $Params
Copy-Groups -NewAccountObject $NewUserObject -CopyAccountObject $CopyUserObject -Credential $Cred
Set-HomeDirectory -AccountObject $NewUserObject -Credential $Cred