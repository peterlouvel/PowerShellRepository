<#
.SYNOPSIS
    Create user account from an exisiting user.
.DESCRIPTION
    Create user account from an exisiting user
.EXAMPLE
    PS C:\> .\Create-User 
    
.NOTES
    General notes
    -- might add in the future -Create Bob.Person -From John.OtherPerson
#>

#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
#endregion Variables

# Functions are at the top so the script engine won't complain about not knowing a funciton.
function PickStaff{
    $Servs = Get-ADUser -Filter {Name -like $UserPick.Text}
    $LblShow.Text = $Servs.SamAccountName
    #$TboxStatus.Text = "Copy Groups"
}

#region Functions
function FilterUser{
    $LblShow.Text = ""
    $SearchFilter = '*' + $TxtFilter.Text + '*'
    if ($SearchFilter -ne '**') {
        $Servs = Get-ADUser -Filter {Name -like $SearchFilter}
    } else {
        $Servs = ''
    }
    #   $Servs = Get-Service | Select-Object -Property name
    $UserPick.Items.Clear()
    $ItemsInBox = $Servs.Length
    if ($ItemsInBox -ge ($NumberOfShownItems + 1) ){
        $UserPick.Height = 16 * ($NumberOfShownItems + 1)
    } elseif ($ItemsInBox -ge 1){
        $UserPick.Height = 16 * ($ItemsInBox + 1)
    } else { #can't show one item when height is below 20
        $UserPick.Height = 20
    }
    $LblPick.text = "Pick one of the "+($ItemsInBox)+" users"
    if ( $ItemsInBox -eq 0){

    }else{
        $UserPick.Items.AddRange($Servs.Name)
    }
}
function DoIt{

    if ($TxtNewUser.text) {}

    $Username = $UserNameTxtBox.Text

    $passwordAU = $PasswordTxtBox.Text
    $SecureStringPwdAU = $passwordAU | ConvertTo-SecureString -AsPlainText -Force
    $credAU = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdAU
    
    $passwordNZ = $PasswordTxtBox.Text
    $SecureStringPwdNZ = $passwordNZ | ConvertTo-SecureString -AsPlainText -Force
    $credNZ = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdNZ
    
    $passwordEDMI = $PasswordTxtBox.Text
    $SecureStringPwdEDMI = $passwordEDMI | ConvertTo-SecureString -AsPlainText -Force
    $credEDMI = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdEDMI
    
    $passwordSG = $PasswordTxtBox.Text
    $SecureStringPwdSG = $passwordSG | ConvertTo-SecureString -AsPlainText -Force
    $credSG = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdSG
    
    $User = Get-ADUser -Identity test.user
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
#region Form
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                           = New-Object system.Windows.Forms.Form
$Form.ClientSize                = '800,400'
$Form.text                      = "Create User from another users account"
$Form.TopMost                   = $true
#endregion Form
#region BtnService
$BtnCommand                     = New-Object System.Windows.Forms.Button
$BtnCommand.text                = "----"
$BtnCommand.width               = 90
$BtnCommand.height              = 30
$BtnCommand.location            = '25,360'
$BtnCommand.Font                = $Font
#endregion BtnService
#region LbleUsername
$LbleUsername                   = New-Object system.Windows.Forms.Label
$LbleUsername.text              = "Admin Username"
$LbleUsername.AutoSize          = $true
$LbleUsername.width             = 100
$LbleUsername.height            = 10
$LbleUsername.location          = '25,10'
$LbleUsername.Font              = $Font
#endregion LbleUsername
#region UserNameTxtBox
$UserNameTxtBox                 = New-Object System.Windows.Forms.TextBox
$UserNameTxtBox.text            = "peterl_"
$UserNameTxtBox.width           = 100
$UserNameTxtBox.height          = 10
$UserNameTxtBox.location        = '25,30'
$UserNameTxtBox.Font            = $Font
#endregion UserNameTxtBox
#region LblePassword
$LblePassword                   = New-Object system.Windows.Forms.Label
$LblePassword.text              = "Admin Password"
$LblePassword.AutoSize          = $true
$LblePassword.width             = 100
$LblePassword.height            = 10
$LblePassword.location          = '150,10'
$LblePassword.Font              = $Font
#endregion LbleUsername
#region PasswordTxtBox
$PasswordTxtBox                 = New-Object System.Windows.Forms.TextBox
$PasswordTxtBox.text            = ""
$PasswordTxtBox.width           = 100
$PasswordTxtBox.height          = 10
$PasswordTxtBox.location        = '150,30'
$PasswordTxtBox.Font            = $Font
#endregion UserNameTxtBox
#region LbleNewUser
$LbleNewUser                    = New-Object system.Windows.Forms.Label
$LbleNewUser.text               = "New user account to create"
$LbleNewUser.AutoSize           = $true
$LbleNewUser.width              = 100
$LbleNewUser.height             = 10
$LbleNewUser.location           = '25,60'
$LbleNewUser.Font               = $Font
#endregion LbleNewUser
#region TxtNewUser
$TxtNewUser                     = New-Object System.Windows.Forms.TextBox
$TxtNewUser.text                = ""
$TxtNewUser.width               = 314
$TxtNewUser.height              = 10
$TxtNewUser.location            = '25,80'
$TxtNewUser.Font                = $Font
#endregion TxtNewUser
#region LblePick
$LblTxtFilter                   = New-Object system.Windows.Forms.Label
$LblTxtFilter.text              = "Search for User (filter box) to copy from"
$LblTxtFilter.AutoSize          = $true
$LblTxtFilter.width             = 25
$LblTxtFilter.height            = 10
$LblTxtFilter.location          = '25,110'
$LblTxtFilter.Font              = $Font
#endregion LblePick
#region UserType
$TxtFilter                      = New-Object System.Windows.Forms.TextBox
$TxtFilter.text                 = ""
$TxtFilter.width                = 314
$TxtFilter.height               = 10
$TxtFilter.location             = '25,130'
$TxtFilter.Font                 = $Font
#endregion UserType
#region LblePick
$LblPick                        = New-Object system.Windows.Forms.Label
$LblPick.text                   = "Pick a User to copy from"
$LblPick.AutoSize               = $true
$LblPick.width                  = 25
$LblPick.height                 = 10
$LblPick.location               = '25,160'
$LblPick.Font                   = $Font
#endregion LblePick
#region LblShow
$LblShow                        = New-Object system.Windows.Forms.Label
$LblShow.AutoSize               = $true
$LblShow.width                  = 25
$LblShow.height                 = 10
$LblShow.location               = '25,288'
$LblShow.Font                   = $Font
$LblShow.BorderStyle            = 1
#endregion LblShow
#region TboxStatus
$TboxStatus                     = New-Object system.Windows.Forms.Label
$TboxStatus.width               = 314
$TboxStatus.height              = 20
$TboxStatus.location            = '27,336'
$TboxStatus.Font                = $Font
$TboxStatus.BorderStyle         = 2
#endregion TboxStatus
#region LblCurrent
$LblCurrent                     = New-Object system.Windows.Forms.Label
$LblCurrent.text                = "Curent Status"
$LblCurrent.AutoSize            = $true
$LblCurrent.width               = 25
$LblCurrent.height              = 10
$LblCurrent.location            = '25,320'
$LblCurrent.Font                = $Font
#endregion LblCurrent
#region UserPick
$UserPick                       = New-Object System.Windows.Forms.ListBox
$UserPick.Width                 = 318
$UserPick.location              = '25,180'
$UserPick.Font                  = $Font
#endregion UserPick
#region UserGroups
$UserGroups                     = New-Object System.Windows.Forms.ListBox
$UserGroups.Width               = 350
$UserGroups.Height              = 360
$UserGroups.location            = '400,20'
$UserGroups.Font                = $Font
#endregion UserGroups
$Form.controls.AddRange(@($LbleNewUser,$TxtNewUser,$BtnCommand,$LbleUsername,$UserNameTxtBox,$PasswordTxtBox,$LblePassword,$LblTxtFilter,$TxtFilter,$UserPick,$LblPick,$TboxStatus,$LblCurrent,$LblShow,$UserGroups))
#endregion GUI

#region LinkFunctions
$UserPick.Add_SelectedValueChanged({ PickStaff $this $_ })
$TxtFilter.Add_TextChanged({ FilterUser $this $_ })
$BtnCommand.Add_Click({ DoIt $this $_ })
#endregion LinkFunctions
[void]$Form.ShowDialog()


FilterUser

#Leave at the end of the script


