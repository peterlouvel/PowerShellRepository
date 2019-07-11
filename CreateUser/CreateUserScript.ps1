$TxtNewUser_KeyDown = {
    if ($_.KeyCode -eq "Enter") {
        FuncEnable_ButtonCreate
    }
    # not working - can't detect TAB key. tried also with     if ($_.KeyCode -eq 9 )
    if ($_.KeyCode -eq "Tab") {
        FuncEnable_ButtonCreate
    }
}


$ChkPasswordSame_CheckedChanged = {
}
$SearchUserTextBox = {
}
$CreateUser_Load = {
    $ListBoxGroupsCopy.Font            = $Font
    $ListBoxGroupsCopy.ScrollBars      = "Vertical"
    
    $ChkUsernameSame.Checked            = $true
    $ChkPasswordSame.Checked            = $true
    
    $ListBoxPickUser.Font              = $Font

    # $TxtBoxDisplayOutput.ReadOnly       = $true
    $TxtBoxDisplayOutput.ScrollBars     = "Vertical"
    $TxtBoxDisplayOutput.ForeColor      = 'Green'

    # $TxtBoxDisplayError.ReadOnly        = $true
    $TxtBoxDisplayError.ScrollBars      = "Vertical"
    $TxtBoxDisplayError.ForeColor       = 'Red'

    $BtnCreateUser.Visible              = $False         
    $BtnCopyGroup.Visible               = $False    
    
    switch ($env:USERname) {
        "scottw"          {$TxtAdminUsernameAU.text = "scottw_"
                            FuncErrorOut "You need to run this with your admin account"}
        "peter.louvel"    {$TxtAdminUsernameAU.text = "peterl_"
                            FuncErrorOut "You need to run this with your admin account"}
        "blair.townley"   {$TxtAdminUsernameAU.text = "blair.townley_"
                            FuncErrorOut "You need to run this with your admin account"}
        "scottw_"         {$TxtAdminUsernameAU.text = "scottw_"}
        "peterl_"         {$TxtAdminUsernameAU.text = "peterl_"}
        "blair.townley_"  {$TxtAdminUsernameAU.text = "blair.townley_"}
    }
    FuncCopyUsername

    $TxtAdminPasswordAU.PasswordChar    = '*';
    $TxtAdminPasswordNZ.PasswordChar    = '*';
    $TxtAdminPasswordEDMI.PasswordChar  = '*';
    $TxtAdminPasswordAU.Text = "Nashua^edmi^01"
    FuncCopyPassword

    FuncFilterUser
    FuncGeneratePasswordForUser
}
$TxtAdminUsernameAU_TextChanged = {
    FuncCopyUsername
}
$TxtAdminPasswordAU_TextChanged = {
    FuncCopyPassword
}
$ListBoxPickUser_SelectedValueChanged = {
    FuncPickStaff
}
$TxtSearchUser_TextChanged = {
    FuncFilterUser
}
$BtnCopyGroup_Click = {
    FuncCopyGroup
}
$BtnCreateUser_Click = {
    FuncCreateUser
}
$BtnGeneratePassword_Click = {
    FuncGeneratePasswordForUser
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'CreateUserScript.designer.ps1')
#


# $TxtNewUser_KeyDown({
#     if ($_.KeyCode -eq "Enter") {
#         FuncEnable_ButtonCreate $this $_
#     }
#     # not working - can't detect TAB key. tried also with     if ($_.KeyCode -eq 9 )
#     if ($_.KeyCode -eq "Tab") {
#         FuncEnable_ButtonCreate $this $_
#     }
# })

#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
$AllUsers           = Get-ADUser -Filter {Name -like "*"}
$User               = Get-ADUser -Identity "peter.louvel" -Properties *
$NewUserExists      = $false
$UserCaps           = (Get-Culture).TextInfo.ToTitleCase("Name")
#endregion Variables

#region Functions
function FuncMessageOut($message){
    $TxtBoxDisplayOutput.AppendText("$message`n")
}
function FuncErrorOut($message){
    $TxtBoxDisplayError.AppendText("$message`n")
}
function FuncGeneratePasswordForUser{
    # FuncMessageOut "GeneratePasswordForUser"   
    $TxtNewUserPassword.Text = [System.Web.Security.Membership]::GeneratePassword(10,3)
}
function FuncCopyUsername{
    # FuncMessageOut "CopyUsername"   
    if ($ChkUsernameSame.Checked -eq $true){
        $TxtAdminUsernameNZ.Text = $TxtAdminUsernameAU.Text
        $TxtAdminUsernameEDMI.Text = $TxtAdminUsernameAU.Text
    } 
}
function FuncCopyPassword{
    # FuncMessageOut "CopyPassword"   
    if ($ChkUsernameSame.Checked -eq $true){
        $TxtAdminPasswordNZ.Text = $TxtAdminPasswordAU.Text
        $TxtAdminPasswordEDMI.Text = $TxtAdminPasswordAU.Text
    } 
}
function FuncEnable_ButtonCreate{
    # FuncMessageOut "Enable_ButtonCreate"   
    if ($TxtNewUser.TextLength -gt 0 ) {
        FuncMessageOut "TxtNewUser.TextLength -gt 0"   
        FuncMessageOut "$LblOU.Length"
        FuncMessageOut "before length $LblOU.Text"

        if ( $LblOU.Length  -gt 0) {
            # FuncMessageOut "$LblOU.TextLength  -gt 0"   
            if ($TxtAdminPasswordEDMI.TextLength -gt 0) {
                # FuncMessageOut "TxtAdminPasswordEDMI.TextLength -gt 0"   
                if ($NewUserExists) {
                    # FuncMessageOut "NewUserExists"   
                    $BtnCreateUser.Visible = $true 
                    $BtnCopyGroup.Visible = $false
                } else {
                    # FuncMessageOut "Not NewUserExists"   
                    $BtnCreateUser.Visible = $false 
                    $BtnCopyGroup.Visible = $true
                }
            }
        } else {
            # FuncMessageOut "Fail length $LblOU.TextLength"
        }
    }
}
function FuncCheckUserExists{
    # FuncMessageOut "CheckUserExists"   
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
function FuncCreateUser{ 
    # FuncMessageOut "CreateUser"   
    FuncCheckUserExists
    
    If ($NewUserExists) {
        # was looking at trying to run the script from a normal account and
        # using the admin account to create the new user  
        # *can't get New-ADUser to work with the credentials
        # $Username = $TxtAdminUsernameAU.Text
        # $passwordAU = $TxtAdminPasswordAU.Text
        # $SecureStringPwdAU = $passwordAU | ConvertTo-SecureString -AsPlainText -Force
        # $credAU = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdAU

        FuncMessageOut "Creating user $UserCaps in OU $UserOU "
        $userInstance = Get-ADUser -Identity $LblShow.Text -Properties *
        # userInstatance doesn't seem to work
        New-ADUser -Name "$UserLowerCase" -path "$UserOU" -DisplayName "$UserCaps" -Instance "$userInstance"
    } else {
        FuncErrorOut "User '$NewUser' already exists in OU '$UserOU' "
    }
    # clears the error so when Get-ADUser is run a second time it can test 
    # if the user is being added a second time
    $AllUsers = Get-ADUser -Filter {Name -like "*"}
    $Error.Clear()
}
function FuncPickStaff{
    # FuncMessageOut "PickStaff"
    FuncEnable_ButtonCreate
    
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
function FuncFilterUser{
    # FuncMessageOut "FilterUser"
    
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
function FuncCopyGroup{
    # FuncMessageOut "CopyGroup"
    
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
        FuncMessageOut "$server"
        try {
            Set-ADObject -Identity $UserGroup -Add @{"member"=$User.DistinguishedName} -Server $Server -Credential $cred
        } Catch {
            FuncErrorOut "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
        }
        $counter++
    }
}
#endregion Functions







$CreateUser.ShowDialog()