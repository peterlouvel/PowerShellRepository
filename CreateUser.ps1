<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    CreateUse
#>
#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
#endregion Variables
# Functions are at the top so the script engine won't complain about not knowing a funciton.
function PickStaff{
    $Servs = Get-ADUser -Filter {Name -like $ListViewPickUser.Text}
    $LblShow.Text = $Servs.SamAccountName
    $LblGroupsCopy.Text = "Groups from " + $LblShow.Text + " to add to new User"
    #$TboxStatus.Text = "Copy Groups"
}

#region Functions
function FilterUser{
    $LblGroupsCopy.Text = "Groups to add to new User"
    $LblShow.Text = ""    
    $TxtSearchUser = '*' + $TxtSearchUser.Text + '*'
    if ($TxtSearchUser -ne '**') {
        $Servs = Get-ADUser -Filter {Name -like $TxtSearchUser}
    } else {
        $Servs = ''
    }
    #   $Servs = Get-Service | Select-Object -Property name
    $ListViewPickUser.Items.Clear()
    $ItemsInBox = $Servs.Length
    if ($ItemsInBox -ge ($NumberOfShownItems + 1) ){
        $ListViewPickUser.Height = 16 * ($NumberOfShownItems + 1)
    } elseif ($ItemsInBox -ge 1){
        $ListViewPickUser.Height = 16 * ($ItemsInBox + 1)
    } else { #can't show one item when height is below 20
        $ListViewPickUser.Height = 20
    }
    $LblPickUser.text = "Pick one of the "+($ItemsInBox)+" users"
    if ( $ItemsInBox -eq 0){

    }else{
        $ListViewPickUser.Items.AddRange($Servs.Name)
    }
}
function DoIt{

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
    
    $User = Get-ADUser -Identity TxtNewUser.Text
    $User
    $UserCopyFrom = Get-ADUser -Identity $LblShow.Text -Properties *
    $UserCopyFrom
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
            Write-Host -ForegroundColor Green $server 
        } Catch {
            Write-Host -ForegroundColor Red "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
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
$LblAdminUsernameAU.Font         = 'Microsoft Sans Serif,10'

$LblAdminUsernameNZ              = New-Object system.Windows.Forms.Label
$LblAdminUsernameNZ.text         = "Admin Username NZ"
$LblAdminUsernameNZ.AutoSize     = $true
$LblAdminUsernameNZ.width        = 25
$LblAdminUsernameNZ.height       = 10
$LblAdminUsernameNZ.location     = New-Object System.Drawing.Point(20,70)
$LblAdminUsernameNZ.Font         = 'Microsoft Sans Serif,10'

$LblAdminUsernameEDMI            = New-Object system.Windows.Forms.Label
$LblAdminUsernameEDMI.text       = "Admin Username EDMI"
$LblAdminUsernameEDMI.AutoSize   = $true
$LblAdminUsernameEDMI.width      = 25
$LblAdminUsernameEDMI.height     = 10
$LblAdminUsernameEDMI.location   = New-Object System.Drawing.Point(20,120)
$LblAdminUsernameEDMI.Font       = 'Microsoft Sans Serif,10'

$TxtAdminUsernameAU              = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameAU.multiline    = $false
$TxtAdminUsernameAU.text         = "peterl_"
$TxtAdminUsernameAU.width        = 150
$TxtAdminUsernameAU.height       = 20
$TxtAdminUsernameAU.location     = New-Object System.Drawing.Point(20,40)
$TxtAdminUsernameAU.Font         = 'Microsoft Sans Serif,10'

$TxtAdminUsernameNZ              = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameNZ.multiline    = $false
$TxtAdminUsernameNZ.text         = "peterl_"
$TxtAdminUsernameNZ.width        = 150
$TxtAdminUsernameNZ.height       = 20
$TxtAdminUsernameNZ.location     = New-Object System.Drawing.Point(20,90)
$TxtAdminUsernameNZ.Font         = 'Microsoft Sans Serif,10'

$TxtAdminUsernameEDMI            = New-Object system.Windows.Forms.TextBox
$TxtAdminUsernameEDMI.multiline  = $false
$TxtAdminUsernameEDMI.text       = "peterl_"
$TxtAdminUsernameEDMI.width      = 150
$TxtAdminUsernameEDMI.height     = 20
$TxtAdminUsernameEDMI.location   = New-Object System.Drawing.Point(20,140)
$TxtAdminUsernameEDMI.Font       = 'Microsoft Sans Serif,10'

$LblAdminPasswordAU              = New-Object system.Windows.Forms.Label
$LblAdminPasswordAU.text         = "Admin Password AU"
$LblAdminPasswordAU.AutoSize     = $true
$LblAdminPasswordAU.width        = 25
$LblAdminPasswordAU.height       = 10
$LblAdminPasswordAU.location     = New-Object System.Drawing.Point(180,20)
$LblAdminPasswordAU.Font         = 'Microsoft Sans Serif,10'

$LblAdminPasswordNZ              = New-Object system.Windows.Forms.Label
$LblAdminPasswordNZ.text         = "Admin Password NZ"
$LblAdminPasswordNZ.AutoSize     = $true
$LblAdminPasswordNZ.width        = 25
$LblAdminPasswordNZ.height       = 10
$LblAdminPasswordNZ.location     = New-Object System.Drawing.Point(180,70)
$LblAdminPasswordNZ.Font         = 'Microsoft Sans Serif,10'

$LblAdminPasswordEDMI            = New-Object system.Windows.Forms.Label
$LblAdminPasswordEDMI.text       = "Admin Password EDMI"
$LblAdminPasswordEDMI.AutoSize   = $true
$LblAdminPasswordEDMI.width      = 25
$LblAdminPasswordEDMI.height     = 10
$LblAdminPasswordEDMI.location   = New-Object System.Drawing.Point(180,120)
$LblAdminPasswordEDMI.Font       = 'Microsoft Sans Serif,10'

$LblNewUser                      = New-Object system.Windows.Forms.Label
$LblNewUser.text                 = "New User"
$LblNewUser.AutoSize             = $true
$LblNewUser.width                = 25
$LblNewUser.height               = 10
$LblNewUser.location             = New-Object System.Drawing.Point(420,19)
$LblNewUser.Font                 = 'Microsoft Sans Serif,10'

$TxtNewUser                      = New-Object system.Windows.Forms.TextBox
$TxtNewUser.multiline            = $false
$TxtNewUser.width                = 150
$TxtNewUser.height               = 20
$TxtNewUser.location             = New-Object System.Drawing.Point(420,39)
$TxtNewUser.Font                 = 'Microsoft Sans Serif,10'

$ChkUsernameSame                 = New-Object system.Windows.Forms.CheckBox
$ChkUsernameSame.AutoSize        = $false
$ChkUsernameSame.width           = 95
$ChkUsernameSame.height          = 20
$ChkUsernameSame.location        = New-Object System.Drawing.Point(20,6)
$ChkUsernameSame.Font            = 'Microsoft Sans Serif,10'

$ChkPasswordSame                 = New-Object system.Windows.Forms.CheckBox
$ChkPasswordSame.AutoSize        = $false
$ChkPasswordSame.width           = 95
$ChkPasswordSame.height          = 20
$ChkPasswordSame.location        = New-Object System.Drawing.Point(180,6)
$ChkPasswordSame.Font            = 'Microsoft Sans Serif,10'

$TxtNewUserPassword              = New-Object system.Windows.Forms.TextBox
$TxtNewUserPassword.multiline    = $false
$TxtNewUserPassword.width        = 150
$TxtNewUserPassword.height       = 20
$TxtNewUserPassword.location     = New-Object System.Drawing.Point(580,40)
$TxtNewUserPassword.Font         = 'Microsoft Sans Serif,10'

$LblNewUserPassword              = New-Object system.Windows.Forms.Label
$LblNewUserPassword.text         = "New User Password"
$LblNewUserPassword.AutoSize     = $true
$LblNewUserPassword.width        = 25
$LblNewUserPassword.height       = 10
$LblNewUserPassword.location     = New-Object System.Drawing.Point(580,20)
$LblNewUserPassword.Font         = 'Microsoft Sans Serif,10'

$LblSearchUser                   = New-Object system.Windows.Forms.Label
$LblSearchUser.text              = "Search for User (filter box) to copy from"
$LblSearchUser.AutoSize          = $true
$LblSearchUser.width             = 25
$LblSearchUser.height            = 10
$LblSearchUser.location          = New-Object System.Drawing.Point(20,200)
$LblSearchUser.Font              = 'Microsoft Sans Serif,10'

$TxtSearchUser                   = New-Object system.Windows.Forms.TextBox
$TxtSearchUser.multiline         = $false
$TxtSearchUser.width             = 150
$TxtSearchUser.height            = 20
$TxtSearchUser.location          = New-Object System.Drawing.Point(20,220)
$TxtSearchUser.Font              = 'Microsoft Sans Serif,10'

$TxtAdminPasswordAU              = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordAU.multiline    = $false
$TxtAdminPasswordAU.width        = 150
$TxtAdminPasswordAU.height       = 20
$TxtAdminPasswordAU.location     = New-Object System.Drawing.Point(180,40)
$TxtAdminPasswordAU.Font         = 'Microsoft Sans Serif,10'

$TxtAdminPasswordNZ              = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordNZ.multiline    = $false
$TxtAdminPasswordNZ.width        = 150
$TxtAdminPasswordNZ.height       = 20
$TxtAdminPasswordNZ.location     = New-Object System.Drawing.Point(180,90)
$TxtAdminPasswordNZ.Font         = 'Microsoft Sans Serif,10'

$TxtAdminPasswordEDMI            = New-Object system.Windows.Forms.TextBox
$TxtAdminPasswordEDMI.multiline  = $false
$TxtAdminPasswordEDMI.width      = 150
$TxtAdminPasswordEDMI.height     = 20
$TxtAdminPasswordEDMI.location   = New-Object System.Drawing.Point(180,140)
$TxtAdminPasswordEDMI.Font       = 'Microsoft Sans Serif,10'

$LblPickUser                     = New-Object system.Windows.Forms.Label
$LblPickUser.text                = "Pick a User to copy from"
$LblPickUser.AutoSize            = $true
$LblPickUser.width               = 25
$LblPickUser.height              = 10
$LblPickUser.location            = New-Object System.Drawing.Point(20,250)
$LblPickUser.Font                = 'Microsoft Sans Serif,10'

$ListViewGroupsCopy              = New-Object system.Windows.Forms.ListView
$ListViewGroupsCopy.text         = "listView"
$ListViewGroupsCopy.width        = 310
$ListViewGroupsCopy.height       = 260
$ListViewGroupsCopy.location     = New-Object System.Drawing.Point(420,90)

$LblGroupsCopy                   = New-Object system.Windows.Forms.Label
$LblGroupsCopy.text              = "Groups to add to new User"
$LblGroupsCopy.AutoSize          = $true
$LblGroupsCopy.width             = 25
$LblGroupsCopy.height            = 10
$LblGroupsCopy.location          = New-Object System.Drawing.Point(424,69)
$LblGroupsCopy.Font              = 'Microsoft Sans Serif,10'

$ListViewPickUser                = New-Object system.Windows.Forms.ListBox
$ListViewPickUser.text           = "listBox"
$ListViewPickUser.width          = 320
$ListViewPickUser.height         = 80
$ListViewPickUser.location       = New-Object System.Drawing.Point(20,270)

$LblShow                         = New-Object system.Windows.Forms.Label
$LblShow.text                    = "label"
$LblShow.AutoSize                = $true
$LblShow.width                   = 25
$LblShow.height                  = 10
$LblShow.location                = New-Object System.Drawing.Point(192,220)
$LblShow.Font                    = 'Microsoft Sans Serif,10'

$CreateUser.controls.AddRange(@($LblAdminUsernameAU,$LblAdminUsernameNZ,$LblAdminUsernameEDMI,$TxtAdminUsernameAU,$TxtAdminUsernameNZ,$TxtAdminUsernameEDMI,$LblAdminPasswordAU,$LblAdminPasswordNZ,$LblAdminPasswordEDMI,$LblNewUser,$TxtNewUser,$ChkUsernameSame,$ChkPasswordSame,$TxtNewUserPassword,$LblNewUserPassword,$LblSearchUser,$TxtSearchUser,$TxtAdminPasswordAU,$TxtAdminPasswordNZ,$TxtAdminPasswordEDMI,$LblPickUser,$ListViewGroupsCopy,$LblGroupsCopy,$ListViewPickUser,$LblShow))
#endregion GUI

#region LinkFunctions
$ListViewPickUser.Add_SelectedValueChanged({ PickStaff $this $_ })
$TxtSearchUser.Add_TextChanged({ FilterUser $this $_ })
#$BtnCommand.Add_Click({ DoIt $this $_ })
#endregion LinkFunctions

$TxtAdminPasswordAU.PasswordChar = '*';
$TxtAdminPasswordNZ.PasswordChar = '*';
$TxtAdminPasswordEDMI.PasswordChar = '*';
FilterUser

[void]$CreateUser.ShowDialog()
