<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    CreateUse
#>
#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
$AllUsers           = Get-ADUser -Filter {Name -like "*"}
$User               = Get-ADUser -Identity "peter.louvel" -Properties *
$NewUserExists      = $false
#endregion Variables
# Functions are at the top so the script engine won't complain about not knowing a funciton.

#region Functions
function f_MessageOut($message){
    $TxtBoxDisplayOutput.AppendText("$message`n")
}
function f_ErrorOut($message){
    $TxtBoxDisplayError.AppendText("$message`n")
}
function f_GeneratePasswordForUser{
    f_MessageOut "GeneratePasswordForUser"   
    $TxtNewUserPassword.Text = [System.Web.Security.Membership]::GeneratePassword(10,3)
}
function f_CopyUsername{
    f_MessageOut "CopyUsername"   
    if ($ChkUsernameSame.Checked -eq $true){
        $TxtAdminUsernameNZ.Text = $TxtAdminUsernameAU.Text
        $TxtAdminUsernameEDMI.Text = $TxtAdminUsernameAU.Text
    } 
}
function f_CopyPassword{
    f_MessageOut "CopyPassword"   
    if ($ChkUsernameSame.Checked -eq $true){
        $TxtAdminPasswordNZ.Text = $TxtAdminPasswordAU.Text
        $TxtAdminPasswordEDMI.Text = $TxtAdminPasswordAU.Text
    } 
}
function f_Enable_ButtonCreate{
    f_MessageOut "Enable_ButtonCreate"   

    if ($TxtNewUser.TextLength -gt 0 ) {
        if ( ($LblOU.Text).Length  -gt 0) {
            if ($TxtAdminPasswordEDMI.TextLength -gt 0) {
                if ($NewUserExists) {
                    $BtnCreateUser.Visible = $true 
                    $BtnCopyGroup.Visible = $false
                } else {
                    $BtnCreateUser.Visible = $false 
                    $BtnCopyGroup.Visible = $true
                }
            }
        }
    }
}
function f_CheckUserExists{
    f_MessageOut "CheckUserExists"   

    # (Get-Culture).User1Var.ToTitleCase
    $UserLowerCase = $TxtNewUser.Text.ToLower()
    $UserCaps = (Get-Culture).TextInfo.ToTitleCase($UserLowerCase) -replace '\.',' '
    
    try {
        $User = Get-ADUser -Identity $UserLowerCase -Properties *
        $UserOU = ($user.DistinguishedName -split ",",2)[1]
        $NewUserExists = $false
    } Catch {
        $NewUserExists = $true
        $UserOU = $LblOU.Text  
    }
}
function f_CreateUser{ 
    f_MessageOut "CreateUser"   
    f_CheckUserExists
    
    If ($NewUserExists) {
        # was looking at trying to run the script from a normal account and
        # using the admin account to create the new user  
        # *can't get New-ADUser to work with the credentials
        # $Username = $TxtAdminUsernameAU.Text
        # $passwordAU = $TxtAdminPasswordAU.Text
        # $SecureStringPwdAU = $passwordAU | ConvertTo-SecureString -AsPlainText -Force
        # $credAU = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdAU

        f_MessageOut "Creating user $UserCaps in OU $UserOU "
        $userInstance = Get-ADUser -Identity $LblShow.Text -Properties *
        # userInstatance doesn't seem to work
        New-ADUser -Name "$UserLowerCase" -path "$UserOU" -DisplayName "$UserCaps" -Instance "$userInstance"
    } else {
        f_ErrorOut "User '$NewUser' already exists in OU '$UserOU' "
    }
    # clears the error so when Get-ADUser is run a second time it can test 
    # if the user is being added a second time
    $AllUsers = Get-ADUser -Filter {Name -like "*"}
    $Error.Clear()
}
function f_PickStaff{
    f_MessageOut "PickStaff"
    f_Enable_ButtonCreate
    
    $ListBoxGroupsCopy.Items.Clear()
    $UserFiltered = Get-ADUser -Filter {Name -like $ListBoxPickUser.Text}
    $LblShow.Text = $UserFiltered.SamAccountName
    $LblGroupsCopy.Text = "Groups from " + $LblShow.Text + " to add to new User"
    $UserCopyFrom = Get-ADUser -Identity $LblShow.Text -Properties *
    $UserCopyFromOU = ($UserCopyFrom.DistinguishedName -split ",",2)[1]
    $LblOU.Text = $UserCopyFromOU
    foreach ($UserGroup in $UserCopyFrom.MemberOf) {
        $GroupName = ($UserGroup -split ",",2)[0]
        $ListBoxGroupsCopy.Items.Add($GroupName.Substring(3))
    }
    
}

function f_FilterUser{
    f_MessageOut "FilterUser"
    
    $LblGroupsCopy.Text = "Groups to add to new User"
    $LblShow.Text = ""
    $TxtSearchUser = '*' + $TxtSearchUser.Text + '*'
    if ($TxtSearchUser -ne '**') {
        $UserFiltered = $AllUsers | Where-Object -Property Name -like $TxtSearchUser
        # $UserFiltered = Get-ADUser -Filter {Name -like $TxtSearchUser}
    } else {
        $UserFiltered = ''
    }
    #   $UserFiltered = Get-Service | Select-Object -Property name
    $ListBoxPickUser.Items.Clear()
    $ItemsInBox = $UserFiltered.Length
    if ($ItemsInBox -ge ($NumberOfShownItems + 1) ){
        $ListBoxPickUser.Height = 16 * ($NumberOfShownItems + 1)
    } elseif ($ItemsInBox -ge 1){
        $ListBoxPickUser.Height = 16 * ($ItemsInBox + 1)
    } else { #can't show one item when height is below 20
        $ListBoxPickUser.Height = 20
    }
    $LblPickUser.text = "Pick one of the "+($ItemsInBox)+" users"
    if ( $ItemsInBox -eq 0){

    }else{
        $ListBoxPickUser.Items.AddRange($UserFiltered.Name)
    }
}
function f_CopyGroup{
    f_MessageOut "CopyGroup"
    
    if ($TxtNewUser.text) {}
    
    $Username = $TxtAdminUsernameAU.Text

    $passwordAU = $TxtAdminPasswordAU.Text
    $SecureStringPwdAU = $passwordAU | ConvertTo-SecureString -AsPlainText -Force
    $credAU = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdAU
    
    $passwordNZ = $TxtAdminPasswordNZ.Text
    $SecureStringPwdNZ = $passwordNZ | ConvertTo-SecureString -AsPlainText -Force
    $credNZ = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdNZ
    
    $passwordEDMI = $TxtAdminPasswordEDMI.Text
    $SecureStringPwdEDMI = $passwordEDMI | ConvertTo-SecureString -AsPlainText -Force
    $credEDMI = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdEDMI
    
    $User = Get-ADUser -Identity $TxtNewUser.Text
    message $User
    $UserCopyFrom = Get-ADUser -Identity $LblShow.Text -Properties *
    message $UserCopyFrom
    $counter = 0
    foreach ($UserGroup in $UserCopyFrom.MemberOf) { 
        Write-Host $counter + " " + $UserGroup
        if ($UserGroup.Contains("DC=au")){
            $Server = "au.edmi.local"
            $cred = $credAU
        } elseif ($UserGroup.Contains("DC=nz")) {
            $Server = "nz.edmi.local"
            $cred = $credNZ
        } elseif ($UserGroup.Contains("DC=sg")) {
            $Server = "sg.edmi.local"
            $cred = $credSG
        } else {
            $Server = "edmi.local"
            $cred = $credEDMI
        }
        $Server
        try {
            Set-ADObject -Identity $UserGroup -Add @{"member"=$User.DistinguishedName} -Server $Server -Credential $cred
            f_MessageOut "$server"
        } Catch {
            f_ErrorOut "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
        }
        $counter++
    }
}
#endregion Functions
#region GUI
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$CreateUser                      = New-Object system.Windows.Forms.Form
$CreateUser.ClientSize           = '1200,800'
$CreateUser.text                 = "Create User from another users account"
$CreateUser.TopMost              = $true

$LblAdminUsernameAU              = New-Object system.Windows.Forms.Label
$LblAdminUsernameAU.text         = "Admin Username AU"
$LblAdminUsernameAU.AutoSize     = $true
$LblAdminUsernameAU.width        = 25
$LblAdminUsernameAU.height       = 10
$LblAdminUsernameAU.location     = New-Object System.Drawing.Point(20,20)
$LblAdminUsernameAU.Font         = $Font 

$LblAdminUsernameNZ              = New-Object system.Windows.Forms.Label
$LblAdminUsernameNZ.text         = "Admin Username NZ"
$LblAdminUsernameNZ.AutoSize     = $true
$LblAdminUsernameNZ.width        = 25
$LblAdminUsernameNZ.height       = 10
$LblAdminUsernameNZ.location     = New-Object System.Drawing.Point(20,70)
$LblAdminUsernameNZ.Font         = $Font

$LblAdminUsernameEDMI            = New-Object system.Windows.Forms.Label
$LblAdminUsernameEDMI.text       = "Admin Username EDMI"
$LblAdminUsernameEDMI.AutoSize   = $true
$LblAdminUsernameEDMI.width      = 25
$LblAdminUsernameEDMI.height     = 10
$LblAdminUsernameEDMI.location   = New-Object System.Drawing.Point(20,120)
$LblAdminUsernameEDMI.Font       = $Font

$LblAdminPasswordAU              = New-Object system.Windows.Forms.Label
$LblAdminPasswordAU.text         = "Admin Password AU"
$LblAdminPasswordAU.AutoSize     = $true
$LblAdminPasswordAU.width        = 25
$LblAdminPasswordAU.height       = 10
$LblAdminPasswordAU.location     = New-Object System.Drawing.Point(180,20)
$LblAdminPasswordAU.Font         = $Font

$LblAdminPasswordNZ              = New-Object system.Windows.Forms.Label
$LblAdminPasswordNZ.text         = "Admin Password NZ"
$LblAdminPasswordNZ.AutoSize     = $true
$LblAdminPasswordNZ.width        = 25
$LblAdminPasswordNZ.height       = 10
$LblAdminPasswordNZ.location     = New-Object System.Drawing.Point(180,70)
$LblAdminPasswordNZ.Font         = $Font

$LblAdminPasswordEDMI            = New-Object system.Windows.Forms.Label
$LblAdminPasswordEDMI.text       = "Admin Password EDMI"
$LblAdminPasswordEDMI.AutoSize   = $true
$LblAdminPasswordEDMI.width      = 25
$LblAdminPasswordEDMI.height     = 10
$LblAdminPasswordEDMI.location   = New-Object System.Drawing.Point(180,120)
$LblAdminPasswordEDMI.Font       = $Font

$LblNewUser                      = New-Object system.Windows.Forms.Label
$LblNewUser.text                 = "New User"
$LblNewUser.AutoSize             = $true
$LblNewUser.width                = 25
$LblNewUser.height               = 10
$LblNewUser.location             = New-Object System.Drawing.Point(420,20)
$LblNewUser.Font                 = $Font

$TxtAdminUsernameAU              = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameAU.multiline    = $false
$TxtAdminUsernameAU.text         = ""
$TxtAdminUsernameAU.width        = 150
$TxtAdminUsernameAU.height       = 20
$TxtAdminUsernameAU.location     = New-Object System.Drawing.Point(20,40)
$TxtAdminUsernameAU.Font         = $Font

$TxtAdminPasswordAU              = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordAU.multiline    = $false
$TxtAdminPasswordAU.width        = 150
$TxtAdminPasswordAU.height       = 20
$TxtAdminPasswordAU.location     = New-Object System.Drawing.Point(180,40)
$TxtAdminPasswordAU.Font         = $Font

$TxtAdminUsernameNZ              = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameNZ.multiline    = $false
$TxtAdminUsernameNZ.text         = "peterl_"
$TxtAdminUsernameNZ.width        = 150
$TxtAdminUsernameNZ.height       = 20
$TxtAdminUsernameNZ.location     = New-Object System.Drawing.Point(20,90)
$TxtAdminUsernameNZ.Font         = $Font

$TxtAdminPasswordNZ              = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordNZ.multiline    = $false
$TxtAdminPasswordNZ.width        = 150
$TxtAdminPasswordNZ.height       = 20
$TxtAdminPasswordNZ.location     = New-Object System.Drawing.Point(180,90)
$TxtAdminPasswordNZ.Font         = $Font

$TxtAdminUsernameEDMI            = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameEDMI.multiline  = $false
$TxtAdminUsernameEDMI.text       = "peterl_"
$TxtAdminUsernameEDMI.width      = 150
$TxtAdminUsernameEDMI.height     = 20
$TxtAdminUsernameEDMI.location   = New-Object System.Drawing.Point(20,140)
$TxtAdminUsernameEDMI.Font       = $Font

$TxtAdminPasswordEDMI            = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordEDMI.multiline  = $false
$TxtAdminPasswordEDMI.width      = 150
$TxtAdminPasswordEDMI.height     = 20
$TxtAdminPasswordEDMI.location   = New-Object System.Drawing.Point(180,140)
$TxtAdminPasswordEDMI.Font       = $Font

$TxtNewUser                      = New-Object system.Windows.Forms.TextBox
$TxtNewUser.multiline            = $false
$TxtNewUser.width                = 150
$TxtNewUser.height               = 20
$TxtNewUser.location             = New-Object System.Drawing.Point(420,40)
$TxtNewUser.Font                 = $Font

$ChkUsernameSame                 = New-Object system.Windows.Forms.CheckBox
$ChkUsernameSame.AutoSize        = $false
$ChkUsernameSame.width           = 95
$ChkUsernameSame.height          = 20
$ChkUsernameSame.location        = New-Object System.Drawing.Point(20,5)
$ChkUsernameSame.Font            = $Font

$ChkPasswordSame                 = New-Object system.Windows.Forms.CheckBox
$ChkPasswordSame.AutoSize        = $false
$ChkPasswordSame.width           = 95
$ChkPasswordSame.height          = 20
$ChkPasswordSame.location        = New-Object System.Drawing.Point(180,5)
$ChkPasswordSame.Font            = $Font

$TxtNewUserPassword              = New-Object system.Windows.Forms.TextBox
$TxtNewUserPassword.multiline    = $false
$TxtNewUserPassword.width        = 150
$TxtNewUserPassword.height       = 20
$TxtNewUserPassword.location     = New-Object System.Drawing.Point(580,40)
$TxtNewUserPassword.Font         = $Font

$LblNewUserPassword              = New-Object system.Windows.Forms.Label
$LblNewUserPassword.text         = "New User Password"
$LblNewUserPassword.AutoSize     = $true
$LblNewUserPassword.width        = 25
$LblNewUserPassword.height       = 10
$LblNewUserPassword.location     = New-Object System.Drawing.Point(580,20)
$LblNewUserPassword.Font         = $Font

$LblSearchUser                   = New-Object system.Windows.Forms.Label
$LblSearchUser.text              = "Search for User (filter box) to copy from"
$LblSearchUser.AutoSize          = $true
$LblSearchUser.width             = 25
$LblSearchUser.height            = 10
$LblSearchUser.location          = New-Object System.Drawing.Point(20,200)
$LblSearchUser.Font              = $Font

$TxtSearchUser                   = New-Object system.Windows.Forms.TextBox
$TxtSearchUser.multiline         = $false
$TxtSearchUser.width             = 150
$TxtSearchUser.height            = 20
$TxtSearchUser.location          = New-Object System.Drawing.Point(20,220)
$TxtSearchUser.Font              = $Font

$LblPickUser                     = New-Object system.Windows.Forms.Label
$LblPickUser.text                = "Pick a User to copy from"
$LblPickUser.AutoSize            = $true
$LblPickUser.width               = 25
$LblPickUser.height              = 10
$LblPickUser.location            = New-Object System.Drawing.Point(20,250)
$LblPickUser.Font                = $Font

$ListBoxGroupsCopy              = New-Object system.Windows.Forms.ListBox
$ListBoxGroupsCopy.text         = "ListBox"
$ListBoxGroupsCopy.width        = 310
$ListBoxGroupsCopy.height       = 260
$ListBoxGroupsCopy.location     = New-Object System.Drawing.Point(420,190)

$LblGroupsCopy                   = New-Object system.Windows.Forms.Label
$LblGroupsCopy.text              = "Groups to add to new User"
$LblGroupsCopy.AutoSize          = $true
$LblGroupsCopy.width             = 25
$LblGroupsCopy.height            = 10
$LblGroupsCopy.location          = New-Object System.Drawing.Point(420,169)
$LblGroupsCopy.Font              = $Font

$ListBoxPickUser                = New-Object system.Windows.Forms.ListBox
$ListBoxPickUser.text           = "listBox"
$ListBoxPickUser.width          = 320
$ListBoxPickUser.height         = 80
$ListBoxPickUser.location       = New-Object System.Drawing.Point(20,270)

$LblShow                         = New-Object system.Windows.Forms.Label
$LblShow.text                    = "label name"
$LblShow.AutoSize                = $true
$LblShow.width                   = 25
$LblShow.height                  = 10
$LblShow.location                = New-Object System.Drawing.Point(425,70)
$LblShow.Font                    = $Font

$BtnCopyGroup                    = New-Object system.Windows.Forms.Button
$BtnCopyGroup.text               = "Copy Groups"
$BtnCopyGroup.width              = 100
$BtnCopyGroup.height             = 30
$BtnCopyGroup.location           = New-Object System.Drawing.Point(240,219)
$BtnCopyGroup.Font               = $Font

$BtnCreateUser                   = New-Object system.Windows.Forms.Button
$BtnCreateUser.text              = "Create User"
$BtnCreateUser.width             = 100
$BtnCreateUser.height            = 30
$BtnCreateUser.location          = New-Object System.Drawing.Point(420,123)
$BtnCreateUser.Font              = $Font

$LblOU                           = New-Object system.Windows.Forms.Label
$LblOU.text                      = ""
$LblOU.AutoSize                  = $true
$LblOU.width                     = 25
$LblOU.height                    = 10
$LblOU.location                  = New-Object System.Drawing.Point(425,90)
$LblOU.Font                      = $Font

$BtnGeneratePassword             = New-Object system.Windows.Forms.Button
$BtnGeneratePassword.text        = "Generate Password"
$BtnGeneratePassword.width       = 140
$BtnGeneratePassword.height      = 30
$BtnGeneratePassword.location    = New-Object System.Drawing.Point(740,30)
$BtnGeneratePassword.Font        = $Font

$TxtBoxDisplayOutput             = New-Object system.Windows.Forms.RichTextBox
$TxtBoxDisplayOutput.multiline   = $true
$TxtBoxDisplayOutput.BackColor   = "#ffffff"
$TxtBoxDisplayOutput.width       = 1000
$TxtBoxDisplayOutput.height      = 100
$TxtBoxDisplayOutput.location    = New-Object System.Drawing.Point(20,480)
$TxtBoxDisplayOutput.Font        = 'Microsoft Sans Serif,10'

$TxtBoxDisplayError              = New-Object system.Windows.Forms.RichTextBox
$TxtBoxDisplayError.multiline    = $true
$TxtBoxDisplayError.BackColor    = "#ffffff"
$TxtBoxDisplayError.width        = 1000
$TxtBoxDisplayError.height       = 100
$TxtBoxDisplayError.location     = New-Object System.Drawing.Point(20,600)
$TxtBoxDisplayError.Font         = 'Microsoft Sans Serif,10'

$CreateUser.controls.AddRange(@(
    $TxtAdminUsernameAU,
    $TxtAdminPasswordAU,
    $TxtAdminUsernameNZ,
    $TxtAdminPasswordNZ,
    $TxtAdminUsernameEDMI,
    $TxtAdminPasswordEDMI,

    $TxtNewUser,
    $TxtNewUserPassword,

    $TxtSearchUser,

    $TxtBoxDisplayError,
    $TxtBoxDisplayOutput,
    $BtnGeneratePassword,

    $ListBoxGroupsCopy,
    $LblGroupsCopy,
    $ListBoxPickUser,
    $LblShow,
    $BtnCopyGroup,
    $BtnCreateUser,
    $LblNewUserPassword,
    $LblSearchUser,
    $LblAdminUsernameAU,
    $LblAdminUsernameNZ,
    $LblAdminUsernameEDMI,
    $LblAdminPasswordAU,    
    $LblAdminPasswordNZ,
    $LblAdminPasswordEDMI,
    $LblPickUser,
    $LblNewUser,
    $LblOU,
    $ChkUsernameSame,
    $ChkPasswordSame
    ))

#endregion GUI

#region LinkFunctions
$TxtAdminUsernameAU.Add_TextChanged({ f_CopyUsername $this $_ })
$TxtAdminPasswordAU.Add_TextChanged({ f_CopyPassword $this $_ })
$ListBoxPickUser.Add_SelectedValueChanged({ f_PickStaff $this $_ })
$TxtSearchUser.Add_TextChanged({ f_FilterUser $this $_ })
$BtnCopyGroup.Add_Click({ f_CopyGroup $this $_ })
$BtnCreateUser.Add_Click({ f_CreateUser $this $_ })
$BtnGeneratePassword.Add_Click({ f_GeneratePasswordForUser $this $_ })
$TxtNewUser.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        f_Enable_ButtonCreate $this $_
    }
    # not working - can't detect TAB key. tried also with     if ($_.KeyCode -eq 9 )
    if ($_.KeyCode -eq "Tab") {
        f_Enable_ButtonCreate $this $_
    }
})

$ListBoxGroupsCopy.Font            = $Font
# $ListBoxGroupsCopy.ScrollBars      = "Vertical"

$ChkUsernameSame.Checked            = $true
$ChkPasswordSame.Checked            = $true

$ListBoxPickUser.Font              = $Font
$TxtBoxDisplayOutput.ReadOnly       = $true
$TxtBoxDisplayOutput.ScrollBars     = "Vertical"
$TxtBoxDisplayOutput.ForeColor      = 'Green'
$TxtBoxDisplayError.ReadOnly        = $true
$TxtBoxDisplayError.ScrollBars      = "Vertical"
$TxtBoxDisplayError.ForeColor       = 'Red'
$BtnCreateUser.Visible              = $False         
$BtnCopyGroup.Visible               = $False    

$TxtAdminPasswordAU.PasswordChar    = '*';
$TxtAdminPasswordNZ.PasswordChar    = '*';
$TxtAdminPasswordEDMI.PasswordChar  = '*';
$TxtAdminPasswordAU.Text = "Nashua^edmi^01"
$TxtAdminPasswordNZ.Text = "Nashua^edmi^01"
$TxtAdminPasswordEDMI.Text = "Nashua^edmi^01"

switch ($env:USERname) {
    "scottw"          {$TxtAdminUsernameAU.text = "scottw_"
                        f_ErrorOut "You need to run this with your admin account"}
    "peter.louvel"    {$TxtAdminUsernameAU.text = "peterl_"
                        f_ErrorOut "You need to run this with your admin account"}
    "blair.townley"   {$TxtAdminUsernameAU.text = "blair.townley_"
                        f_ErrorOut "You need to run this with your admin account"}
    "scottw_"         {$TxtAdminUsernameAU.text = "scottw_"}
    "peterl_"         {$TxtAdminUsernameAU.text = "peterl_"}
    "blair.townley_"  {$TxtAdminUsernameAU.text = "blair.townley_"}
}

# $AllUsers = Get-ADUser -Filter {Name -like "*"}

FilterUser
# $TxtNewUserPassword.Text = [System.Web.Security.Membership]::GeneratePassword(10,3)
f_GeneratePasswordForUser


[void]$CreateUser.ShowDialog()
