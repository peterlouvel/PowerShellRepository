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
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
    ,[Parameter(Mandatory=$true)]
    [string]$Title
    ,[Parameter(Mandatory=$false)]
    [string]$UsersDomain = "z"
    # ,[Parameter(Mandatory=$true)]
    # [string]$UserDepartment
)

# Setup the form
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Department'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(100,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a Department:'
$form.Controls.Add($label)
# ------------------------------------------

[array]$Departments = Get-ChildItem -Path '.\Departments\*.txt' | ForEach-Object -Process {[System.IO.Path]::GetFileNameWithoutExtension($_)} 
$NumOfItems = $Departments.Count
if ($NumOfItems -lt 1) {
    Write-Host "No files in directory .\deparment"
    exit
}
$listBox = New-Object System.Windows.Forms.ListBox
foreach ($Department in $Departments) {
    [void] $listBox.Items.Add("$Department")
}
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,18)
$listBox.Height = 80
$listBox.SetSelected(1,$true)
$form.Controls.Add($listBox)
$form.Topmost = $true
$form.Add_Shown({$form.Activate(),$listBox.focus()})
$result = $form.ShowDialog()
# $result
Write-Host ""
if ($result -eq [System.Windows.Forms.DialogResult]::OK){
    $UserDepartment = $listBox.SelectedItem
    # if ($null $UserDepartment )
}else{
    Write-Host "You didn't pick a Department"
    exit
}
Write-Host "You selected Department: " -NoNewline
Write-Host "$UserDepartment" -ForegroundColor Cyan
$DeparmentFile = ".\Departments\$UserDepartment.txt"
$GroupFile = ".\Departments\$UserDepartment.csv"

# Start-Sleep -s 600

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"
if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}
if ($UsersDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    $Location = "Australia"
} elseif ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    $DomainController = "nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    $Location = "New Zealand"
} elseif ($UsersDomain -eq "uk"){    #Not working for some reason
    $End = "@edmi-meters.com"
    $DomainController = "uk.edmi.local"
    $AdminAccount1 = "uk\"+$AdminAccount
    $Location = "United Kingdom"
} elseif ($UsersDomain -eq "sg"){     #Not working for some reason
    $End = "@edmi-meters.com"
    $DomainController = "sg.edmi.local"
    $AdminAccount1 = "sg\"+$AdminAccount
    $Location = "Singapore"
} else {
    Write-Host
    Write-Host "Domain should be AU, NZ, UK, SG" -ForegroundColor Red 
    # $ErrorActionPreference = "SilentlyContinue"
    exit
}
function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
function Set-ScrambledString([string]$inputString){
    $characterArray = $inputString.ToCharArray()
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length
    $outputString = -join $scrambledStringArray
    return $outputString
}
function Set-NewPassword{
    $password = ""
    $password = Get-RandomCharacters -length 5 -characters 'abcdefghkmnprstuvwxyz'
    $password += Get-RandomCharacters -length 3 -characters 'ABCDEFGHKMNPRSTUVWXYZ'
    $password += Get-RandomCharacters -length 2 -characters '23456789'
    $password += Get-RandomCharacters -length 1 -characters '$()=?}][{#*'
    $password = Set-ScrambledString $password   
    return $password 
}
if ($null -eq $Cred){ $Cred = Get-Credential $AdminAccount1 } 
$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'
$SamAccount     = $UserAccount
$newPass        = Set-NewPassword
$Params = @(
    "Department", 
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
)
function Copy-Groups{
    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.ActiveDirectory.Management.ADObject]$NewAccountObject
    )
    foreach ($UserGroup in Get-Content "$GroupFile"){ 
        $GroupName = ($UserGroup -split ",",2)[0]
        if ($UserGroup.Contains("DC=au")){
            Write-Host "AU  -- "$GroupName.Substring(3)
            $Server = "au.edmi.local"
        }elseif ($UserGroup.Contains("DC=nz")){
            Write-Host "NZ  -- "$GroupName.Substring(3)
            $Server = "nz.edmi.local"
        }elseif ($UserGroup.Contains("DC=uk")){
            Write-Host "UK  -- "$GroupName.Substring(3)
            $Server = "uk.edmi.local"
        }elseif ($UserGroup.Contains("DC=sg")){
            Write-Host "SG  -- "$GroupName.Substring(3)
            $Server = "SG.edmi.local"
        }else{
            Write-Host "ROOT  -- "$GroupName.Substring(3)
            $Server = "edmi.local"
        }
        try{
            Set-ADObject -Identity $UserGroup -Add @{"member"=$NewAccountObject.DistinguishedName} -Server $Server -Credential $Cred
            Write-Host "-- [Worked] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Yellow 
        }catch{
            Write-Host "-- [ERROR] $server - $($NewAccountObject.DistinguishedName) " -ForegroundColor Cyan
            Write-Host "   $($Error[0])" -ForegroundColor Red
        }
    }
}
function Copy-User{
    param(
        [Parameter(Mandatory=$true)]
        [String]$SamAccount
    )
    $Email              = $SamAccount + "" + $End
    $FullNewUserName    = $SamAccount -replace '\.',' '
    $Pos                = $FullNewUserName.IndexOf(" ")
    $GivenName          = $FullNewUserName.Substring(0, $Pos)
    $Surname            = $FullNewUserName.Substring($Pos+1)

    $paramDepartment    = Import-PowerShellDataFile $DeparmentFile
    $paramsCreate       = @{  
        Name                = "$FullNewUserName"
        SamAccountName      = "$SamAccount"
        GivenName           = "$GivenName" 
        Surname             = "$Surname" 
        DisplayName         = "$FullNewUserName"
        UserPrincipalName   = "$Email"
        Title               = "$Title"
        Path                = $paramDepartment.Path
        Department          = $paramDepartment.Department
        Office              = $paramDepartment.Office
        City                = $paramDepartment.City
        PostalCode          = $paramDepartment.PostalCode
        POBox               = $paramDepartment.POBox
        HomePage            = $paramDepartment.HomePage
        StreetAddress       = $paramDepartment.StreetAddress
        State               = $paramDepartment.State
        Country             = $paramDepartment.Country
        Company             = $paramDepartment.Company
        Manager             = $paramDepartment.Manager
    }
    Write-Host "Creating new user " -NoNewline 
    Write-Host "$FullNewUserName " -ForegroundColor Cyan -NoNewline 
    Write-Host "$SamAccount" -ForegroundColor Green
    Try{
        New-ADUser  @paramsCreate -Credential $Cred -Server $DomainController  
    }Catch{
        Write-Host "-- New-ADUser  @paramsCreate -Credential $Cred" -ForegroundColor Yellow 
        Write-Host "-- [ERROR] $DomainController - $($SamAccount) - $($Error[0])" -ForegroundColor Red 
    }
    Write-Host "Setting Password"
    Start-Sleep -s 10
    Set-ADAccountPassword -Identity "$SamAccount" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) -Credential $Cred -Server $DomainController
    Write-Host "Enabling Account"
    Enable-ADAccount -Identity "$SamAccount" -Credential $Cred -Server $DomainController
}
Copy-User -SamAccount $SamAccount
Start-Sleep -s 5
Get-ADUser -Identity $SamAccount -Server $DomainController | Set-ADObject -Replace @{co="$Location"} -Credential $Cred -Server $DomainController
Write-Host "-----------------------------------------------------------------------"
# can be qicker if staff is in the same domain as the group, have to wait for backends to sync between domains
Write-Host "Waiting 60 seconds for AD systems to update before adding user to groups." -ForegroundColor Cyan  
Write-Host "This is to give other domains time to sync changes." -ForegroundColor Cyan  
Write-Host "-----------------------------------------------------------------------"
Start-Sleep -s 60
$NewUserObject = Get-ADUser -Identity $SamAccount -Properties $Params -Server $DomainController -Credential $Cred
Copy-Groups -NewAccountObject $NewUserObject
Write-Host "-----------------------------------------------------------------------"
Write-Host "If it fails with " -ForegroundColor Cyan -NoNewline
Write-Host "'The specified account does not exist'"  -ForegroundColor Red -NoNewline
Write-Host ", retry the script again in 15 mins." -ForegroundColor Cyan  
Write-Host "Just to give more time for the domains to sync" -ForegroundColor Cyan  
Write-Host "Just ignore the error you will get about the account already existing." -ForegroundColor Magenta  
Write-Host "-----------------------------------------------------------------------"
Write-Host "$SamAccount" -ForegroundColor Green
Write-Host "Setting users password to " -NoNewline  -ForegroundColor Cyan   
Write-Host "$newPass" -ForegroundColor Green  