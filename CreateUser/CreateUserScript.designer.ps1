$CreateUser = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$LblAdminUsernameAU = $null
[System.Windows.Forms.Label]$LblAdminPasswordAU = $null
[System.Windows.Forms.TextBox]$TxtAdminUsernameAU = $null
[System.Windows.Forms.TextBox]$TxtAdminPasswordAU = $null
[System.Windows.Forms.Label]$LblAdminUsernameNZ = $null
[System.Windows.Forms.Label]$LblAdminPasswordNZ = $null
[System.Windows.Forms.TextBox]$TxtAdminUsernameNZ = $null
[System.Windows.Forms.TextBox]$TxtAdminPasswordNZ = $null
[System.Windows.Forms.Label]$LblAdminUsernameEDMI = $null
[System.Windows.Forms.Label]$LblAdminPasswordEDMI = $null
[System.Windows.Forms.TextBox]$TxtAdminUsernameEDMI = $null
[System.Windows.Forms.TextBox]$TxtAdminPasswordEDMI = $null
[System.Windows.Forms.Label]$LblSearchUser = $null
[System.Windows.Forms.TextBox]$TxtSearchUser = $null
[System.Windows.Forms.Button]$BtnCopyGroup = $null
[System.Windows.Forms.Label]$LblPickUser = $null
[System.Windows.Forms.ListBox]$ListBoxPickUser = $null
[System.Windows.Forms.TextBox]$TxtBoxDisplayOutput = $null
[System.Windows.Forms.TextBox]$TxtBoxDisplayError = $null
[System.Windows.Forms.Label]$LblNewUser = $null
[System.Windows.Forms.TextBox]$TxtNewUser = $null
[System.Windows.Forms.Label]$LblNewUserPassword = $null
[System.Windows.Forms.TextBox]$TxtNewUserPassword = $null
[System.Windows.Forms.Label]$LblShow = $null
[System.Windows.Forms.Label]$LblOU = $null
[System.Windows.Forms.Button]$BtnGeneratePassword = $null
[System.Windows.Forms.Button]$BtnCreateUser = $null
[System.Windows.Forms.Label]$LblGroupsCopy = $null
[System.Windows.Forms.ListBox]$ListBoxGroupsCopy = $null
[System.Windows.Forms.CheckBox]$ChkUsernameSame = $null
[System.Windows.Forms.CheckBox]$ChkPasswordSame = $null
[System.Windows.Forms.Button]$Exit = $null
function InitializeComponent
{
$LblAdminUsernameAU = (New-Object -TypeName System.Windows.Forms.Label)
$LblAdminPasswordAU = (New-Object -TypeName System.Windows.Forms.Label)
$TxtAdminUsernameAU = (New-Object -TypeName System.Windows.Forms.TextBox)
$TxtAdminPasswordAU = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblAdminUsernameNZ = (New-Object -TypeName System.Windows.Forms.Label)
$LblAdminPasswordNZ = (New-Object -TypeName System.Windows.Forms.Label)
$TxtAdminUsernameNZ = (New-Object -TypeName System.Windows.Forms.TextBox)
$TxtAdminPasswordNZ = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblAdminUsernameEDMI = (New-Object -TypeName System.Windows.Forms.Label)
$LblAdminPasswordEDMI = (New-Object -TypeName System.Windows.Forms.Label)
$TxtAdminUsernameEDMI = (New-Object -TypeName System.Windows.Forms.TextBox)
$TxtAdminPasswordEDMI = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblSearchUser = (New-Object -TypeName System.Windows.Forms.Label)
$TxtSearchUser = (New-Object -TypeName System.Windows.Forms.TextBox)
$BtnCopyGroup = (New-Object -TypeName System.Windows.Forms.Button)
$LblPickUser = (New-Object -TypeName System.Windows.Forms.Label)
$ListBoxPickUser = (New-Object -TypeName System.Windows.Forms.ListBox)
$TxtBoxDisplayOutput = (New-Object -TypeName System.Windows.Forms.TextBox)
$TxtBoxDisplayError = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblNewUser = (New-Object -TypeName System.Windows.Forms.Label)
$TxtNewUser = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblNewUserPassword = (New-Object -TypeName System.Windows.Forms.Label)
$TxtNewUserPassword = (New-Object -TypeName System.Windows.Forms.TextBox)
$LblShow = (New-Object -TypeName System.Windows.Forms.Label)
$LblOU = (New-Object -TypeName System.Windows.Forms.Label)
$BtnGeneratePassword = (New-Object -TypeName System.Windows.Forms.Button)
$BtnCreateUser = (New-Object -TypeName System.Windows.Forms.Button)
$LblGroupsCopy = (New-Object -TypeName System.Windows.Forms.Label)
$ListBoxGroupsCopy = (New-Object -TypeName System.Windows.Forms.ListBox)
$ChkUsernameSame = (New-Object -TypeName System.Windows.Forms.CheckBox)
$ChkPasswordSame = (New-Object -TypeName System.Windows.Forms.CheckBox)
$Exit = (New-Object -TypeName System.Windows.Forms.Button)
$CreateUser.SuspendLayout()
#
#LblAdminUsernameAU
#
$LblAdminUsernameAU.AutoSize = $true
$LblAdminUsernameAU.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminUsernameAU.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]20))
$LblAdminUsernameAU.Name = [System.String]'LblAdminUsernameAU'
$LblAdminUsernameAU.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]130,[System.Int32]20))
$LblAdminUsernameAU.TabIndex = [System.Int32]0
$LblAdminUsernameAU.Text = [System.String]'Admin Username AU'
$LblAdminUsernameAU.UseCompatibleTextRendering = $true
#
#LblAdminPasswordAU
#
$LblAdminPasswordAU.AutoSize = $true
$LblAdminPasswordAU.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminPasswordAU.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]20))
$LblAdminPasswordAU.Name = [System.String]'LblAdminPasswordAU'
$LblAdminPasswordAU.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]127,[System.Int32]20))
$LblAdminPasswordAU.TabIndex = [System.Int32]1
$LblAdminPasswordAU.Text = [System.String]'Admin Password AU'
$LblAdminPasswordAU.UseCompatibleTextRendering = $true
#
#TxtAdminUsernameAU
#
$TxtAdminUsernameAU.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]40))
$TxtAdminUsernameAU.Name = [System.String]'TxtAdminUsernameAU'
$TxtAdminUsernameAU.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminUsernameAU.TabIndex = [System.Int32]0
$TxtAdminUsernameAU.WordWrap = $false
$TxtAdminUsernameAU.add_TextChanged($TxtAdminUsernameAU_TextChanged)
#
#TxtAdminPasswordAU
#
$TxtAdminPasswordAU.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]40))
$TxtAdminPasswordAU.Name = [System.String]'TxtAdminPasswordAU'
$TxtAdminPasswordAU.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminPasswordAU.TabIndex = [System.Int32]1
$TxtAdminPasswordAU.add_TextChanged($TxtAdminPasswordAU_TextChanged)
#
#LblAdminUsernameNZ
#
$LblAdminUsernameNZ.AutoSize = $true
$LblAdminUsernameNZ.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminUsernameNZ.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]70))
$LblAdminUsernameNZ.Name = [System.String]'LblAdminUsernameNZ'
$LblAdminUsernameNZ.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]130,[System.Int32]20))
$LblAdminUsernameNZ.TabIndex = [System.Int32]0
$LblAdminUsernameNZ.Text = [System.String]'Admin Username NZ'
$LblAdminUsernameNZ.UseCompatibleTextRendering = $true
#
#LblAdminPasswordNZ
#
$LblAdminPasswordNZ.AutoSize = $true
$LblAdminPasswordNZ.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminPasswordNZ.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]70))
$LblAdminPasswordNZ.Name = [System.String]'LblAdminPasswordNZ'
$LblAdminPasswordNZ.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]127,[System.Int32]20))
$LblAdminPasswordNZ.TabIndex = [System.Int32]1
$LblAdminPasswordNZ.Text = [System.String]'Admin Password NZ'
$LblAdminPasswordNZ.UseCompatibleTextRendering = $true
#
#TxtAdminUsernameNZ
#
$TxtAdminUsernameNZ.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]90))
$TxtAdminUsernameNZ.Name = [System.String]'TxtAdminUsernameNZ'
$TxtAdminUsernameNZ.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminUsernameNZ.TabIndex = [System.Int32]2
$TxtAdminUsernameNZ.WordWrap = $false
#
#TxtAdminPasswordNZ
#
$TxtAdminPasswordNZ.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]90))
$TxtAdminPasswordNZ.Name = [System.String]'TxtAdminPasswordNZ'
$TxtAdminPasswordNZ.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminPasswordNZ.TabIndex = [System.Int32]3
#
#LblAdminUsernameEDMI
#
$LblAdminUsernameEDMI.AutoSize = $true
$LblAdminUsernameEDMI.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminUsernameEDMI.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]120))
$LblAdminUsernameEDMI.Name = [System.String]'LblAdminUsernameEDMI'
$LblAdminUsernameEDMI.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]145,[System.Int32]20))
$LblAdminUsernameEDMI.TabIndex = [System.Int32]0
$LblAdminUsernameEDMI.Text = [System.String]'Admin Username EDMI'
$LblAdminUsernameEDMI.UseCompatibleTextRendering = $true
#
#LblAdminPasswordEDMI
#
$LblAdminPasswordEDMI.AutoSize = $true
$LblAdminPasswordEDMI.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LblAdminPasswordEDMI.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]120))
$LblAdminPasswordEDMI.Name = [System.String]'LblAdminPasswordEDMI'
$LblAdminPasswordEDMI.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]142,[System.Int32]20))
$LblAdminPasswordEDMI.TabIndex = [System.Int32]1
$LblAdminPasswordEDMI.Text = [System.String]'Admin Password EDMI'
$LblAdminPasswordEDMI.UseCompatibleTextRendering = $true
#
#TxtAdminUsernameEDMI
#
$TxtAdminUsernameEDMI.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]140))
$TxtAdminUsernameEDMI.Name = [System.String]'TxtAdminUsernameEDMI'
$TxtAdminUsernameEDMI.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminUsernameEDMI.TabIndex = [System.Int32]4
$TxtAdminUsernameEDMI.WordWrap = $false
#
#TxtAdminPasswordEDMI
#
$TxtAdminPasswordEDMI.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]140))
$TxtAdminPasswordEDMI.Name = [System.String]'TxtAdminPasswordEDMI'
$TxtAdminPasswordEDMI.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtAdminPasswordEDMI.TabIndex = [System.Int32]5
#
#LblSearchUser
#
$LblSearchUser.AutoSize = $true
$LblSearchUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]200))
$LblSearchUser.Name = [System.String]'LblSearchUser'
$LblSearchUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]238,[System.Int32]20))
$LblSearchUser.TabIndex = [System.Int32]4
$LblSearchUser.Text = [System.String]'Search for User (filter box) to copy from'
$LblSearchUser.UseCompatibleTextRendering = $true
#
#TxtSearchUser
#
$TxtSearchUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]220))
$TxtSearchUser.Name = [System.String]'TxtSearchUser'
$TxtSearchUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtSearchUser.TabIndex = [System.Int32]6
$TxtSearchUser.add_TextChanged($TxtSearchUser_TextChanged)
#
#BtnCopyGroup
#
$BtnCopyGroup.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]240,[System.Int32]220))
$BtnCopyGroup.Name = [System.String]'BtnCopyGroup'
$BtnCopyGroup.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]30))
$BtnCopyGroup.TabIndex = [System.Int32]10
$BtnCopyGroup.Text = [System.String]'Copy Groups'
$BtnCopyGroup.UseCompatibleTextRendering = $true
$BtnCopyGroup.UseVisualStyleBackColor = $true
$BtnCopyGroup.add_Click($BtnCopyGroup_Click)
#
#LblPickUser
#
$LblPickUser.AutoSize = $true
$LblPickUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]250))
$LblPickUser.Name = [System.String]'LblPickUser'
$LblPickUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]20))
$LblPickUser.TabIndex = [System.Int32]7
$LblPickUser.Text = [System.String]'Pick a User to copy from'
$LblPickUser.UseCompatibleTextRendering = $true
#
#ListBoxPickUser
#
$ListBoxPickUser.FormattingEnabled = $true
$ListBoxPickUser.ItemHeight = [System.Int32]16
$ListBoxPickUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]270))
$ListBoxPickUser.Name = [System.String]'ListBoxPickUser'
$ListBoxPickUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]320,[System.Int32]68))
$ListBoxPickUser.TabIndex = [System.Int32]8
$ListBoxPickUser.TabStop = $false
$ListBoxPickUser.add_SelectedValueChanged($ListBoxPickUser_SelectedValueChanged)
#
#TxtBoxDisplayOutput
#
$TxtBoxDisplayOutput.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]480))
$TxtBoxDisplayOutput.Multiline = $true
$TxtBoxDisplayOutput.Name = [System.String]'TxtBoxDisplayOutput'
$TxtBoxDisplayOutput.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]800,[System.Int32]100))
$TxtBoxDisplayOutput.TabIndex = [System.Int32]9
$TxtBoxDisplayOutput.TabStop = $false
#
#TxtBoxDisplayError
#
$TxtBoxDisplayError.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]600))
$TxtBoxDisplayError.Multiline = $true
$TxtBoxDisplayError.Name = [System.String]'TxtBoxDisplayError'
$TxtBoxDisplayError.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]800,[System.Int32]100))
$TxtBoxDisplayError.TabIndex = [System.Int32]10
$TxtBoxDisplayError.TabStop = $false
#
#LblNewUser
#
$LblNewUser.AutoSize = $true
$LblNewUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]420,[System.Int32]20))
$LblNewUser.Name = [System.String]'LblNewUser'
$LblNewUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]63,[System.Int32]20))
$LblNewUser.TabIndex = [System.Int32]11
$LblNewUser.Text = [System.String]'New User'
$LblNewUser.UseCompatibleTextRendering = $true
#
#TxtNewUser
#
$TxtNewUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]420,[System.Int32]40))
$TxtNewUser.Name = [System.String]'TxtNewUser'
$TxtNewUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtNewUser.TabIndex = [System.Int32]7
$TxtNewUser.add_KeyDown($TxtNewUser_KeyDown)
#
#LblNewUserPassword
#
$LblNewUserPassword.AutoSize = $true
$LblNewUserPassword.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]580,[System.Int32]20))
$LblNewUserPassword.Name = [System.String]'LblNewUserPassword'
$LblNewUserPassword.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]126,[System.Int32]20))
$LblNewUserPassword.TabIndex = [System.Int32]13
$LblNewUserPassword.Text = [System.String]'New User Password'
$LblNewUserPassword.UseCompatibleTextRendering = $true
#
#TxtNewUserPassword
#
$TxtNewUserPassword.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]580,[System.Int32]40))
$TxtNewUserPassword.Name = [System.String]'TxtNewUserPassword'
$TxtNewUserPassword.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]150,[System.Int32]22))
$TxtNewUserPassword.TabIndex = [System.Int32]8
#
#LblShow
#
$LblShow.AutoSize = $true
$LblShow.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]425,[System.Int32]70))
$LblShow.Name = [System.String]'LblShow'
$LblShow.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]70,[System.Int32]20))
$LblShow.TabIndex = [System.Int32]15
$LblShow.Text = [System.String]'label name'
$LblShow.UseCompatibleTextRendering = $true
#
#LblOU
#
$LblOU.AutoSize = $true
$LblOU.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]425,[System.Int32]90))
$LblOU.Name = [System.String]'LblOU'
$LblOU.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$LblOU.TabIndex = [System.Int32]16
$LblOU.Text = [System.String]'Label OU'
$LblOU.UseCompatibleTextRendering = $true
#
#BtnGeneratePassword
#
$BtnGeneratePassword.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]740,[System.Int32]30))
$BtnGeneratePassword.Name = [System.String]'BtnGeneratePassword'
$BtnGeneratePassword.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]140,[System.Int32]30))
$BtnGeneratePassword.TabIndex = [System.Int32]9
$BtnGeneratePassword.Text = [System.String]'Generate Password'
$BtnGeneratePassword.UseCompatibleTextRendering = $true
$BtnGeneratePassword.UseVisualStyleBackColor = $true
$BtnGeneratePassword.add_Click($BtnGeneratePassword_Click)
#
#BtnCreateUser
#
$BtnCreateUser.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]420,[System.Int32]120))
$BtnCreateUser.Name = [System.String]'BtnCreateUser'
$BtnCreateUser.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]30))
$BtnCreateUser.TabIndex = [System.Int32]11
$BtnCreateUser.Text = [System.String]'Create User'
$BtnCreateUser.UseCompatibleTextRendering = $true
$BtnCreateUser.UseVisualStyleBackColor = $true
$BtnCreateUser.add_Click($BtnCreateUser_Click)
#
#LblGroupsCopy
#
$LblGroupsCopy.AutoSize = $true
$LblGroupsCopy.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]420,[System.Int32]170))
$LblGroupsCopy.Name = [System.String]'LblGroupsCopy'
$LblGroupsCopy.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]164,[System.Int32]20))
$LblGroupsCopy.TabIndex = [System.Int32]19
$LblGroupsCopy.Text = [System.String]'Groups to add to new User'
$LblGroupsCopy.UseCompatibleTextRendering = $true
#
#ListBoxGroupsCopy
#
$ListBoxGroupsCopy.FormattingEnabled = $true
$ListBoxGroupsCopy.ItemHeight = [System.Int32]16
$ListBoxGroupsCopy.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]420,[System.Int32]190))
$ListBoxGroupsCopy.Name = [System.String]'ListBoxGroupsCopy'
$ListBoxGroupsCopy.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]310,[System.Int32]260))
$ListBoxGroupsCopy.TabIndex = [System.Int32]20
$ListBoxGroupsCopy.TabStop = $false
#
#ChkUsernameSame
#
$ChkUsernameSame.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]4))
$ChkUsernameSame.Margin = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]0))
$ChkUsernameSame.Name = [System.String]'ChkUsernameSame'
$ChkUsernameSame.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]20,[System.Int32]20))
$ChkUsernameSame.TabIndex = [System.Int32]12
$ChkUsernameSame.UseCompatibleTextRendering = $true
$ChkUsernameSame.UseVisualStyleBackColor = $true
#
#ChkPasswordSame
#
$ChkPasswordSame.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]180,[System.Int32]4))
$ChkPasswordSame.Margin = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]0))
$ChkPasswordSame.Name = [System.String]'ChkPasswordSame'
$ChkPasswordSame.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]20,[System.Int32]20))
$ChkPasswordSame.TabIndex = [System.Int32]13
$ChkPasswordSame.UseCompatibleTextRendering = $true
$ChkPasswordSame.UseVisualStyleBackColor = $true
$ChkPasswordSame.add_CheckedChanged($ChkPasswordSame_CheckedChanged)
#
#Exit
#
$Exit.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]740,[System.Int32]70))
$Exit.Name = [System.String]'Exit'
$Exit.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]140,[System.Int32]30))
$Exit.TabIndex = [System.Int32]100
$Exit.Text = [System.String]'Quit'
$Exit.UseCompatibleTextRendering = $true
$Exit.UseVisualStyleBackColor = $true
$Exit.add_Click($Exit_Click)
#
#CreateUser
#
$CreateUser.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]927,[System.Int32]800))
$CreateUser.Controls.Add($Exit)
$CreateUser.Controls.Add($ChkPasswordSame)
$CreateUser.Controls.Add($ChkUsernameSame)
$CreateUser.Controls.Add($ListBoxGroupsCopy)
$CreateUser.Controls.Add($LblGroupsCopy)
$CreateUser.Controls.Add($BtnCreateUser)
$CreateUser.Controls.Add($BtnGeneratePassword)
$CreateUser.Controls.Add($LblOU)
$CreateUser.Controls.Add($LblShow)
$CreateUser.Controls.Add($TxtNewUserPassword)
$CreateUser.Controls.Add($LblNewUserPassword)
$CreateUser.Controls.Add($TxtNewUser)
$CreateUser.Controls.Add($LblNewUser)
$CreateUser.Controls.Add($TxtBoxDisplayError)
$CreateUser.Controls.Add($TxtBoxDisplayOutput)
$CreateUser.Controls.Add($ListBoxPickUser)
$CreateUser.Controls.Add($LblPickUser)
$CreateUser.Controls.Add($BtnCopyGroup)
$CreateUser.Controls.Add($TxtSearchUser)
$CreateUser.Controls.Add($LblSearchUser)
$CreateUser.Controls.Add($TxtAdminPasswordAU)
$CreateUser.Controls.Add($TxtAdminUsernameAU)
$CreateUser.Controls.Add($LblAdminPasswordAU)
$CreateUser.Controls.Add($LblAdminUsernameAU)
$CreateUser.Controls.Add($TxtAdminPasswordNZ)
$CreateUser.Controls.Add($TxtAdminUsernameNZ)
$CreateUser.Controls.Add($LblAdminPasswordNZ)
$CreateUser.Controls.Add($LblAdminUsernameNZ)
$CreateUser.Controls.Add($TxtAdminPasswordEDMI)
$CreateUser.Controls.Add($TxtAdminUsernameEDMI)
$CreateUser.Controls.Add($LblAdminPasswordEDMI)
$CreateUser.Controls.Add($LblAdminUsernameEDMI)
$CreateUser.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Microsoft Sans Serif',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CreateUser.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$CreateUser.MaximizeBox = $false
$CreateUser.Text = [System.String]'CreateUser'
$CreateUser.TransparencyKey = [System.Drawing.Color]::Transparent
$CreateUser.add_Load($CreateUser_Load)
$CreateUser.ResumeLayout($false)
$CreateUser.PerformLayout()
Add-Member -InputObject $CreateUser -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminUsernameAU -Value $LblAdminUsernameAU -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminPasswordAU -Value $LblAdminPasswordAU -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminUsernameAU -Value $TxtAdminUsernameAU -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminPasswordAU -Value $TxtAdminPasswordAU -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminUsernameNZ -Value $LblAdminUsernameNZ -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminPasswordNZ -Value $LblAdminPasswordNZ -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminUsernameNZ -Value $TxtAdminUsernameNZ -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminPasswordNZ -Value $TxtAdminPasswordNZ -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminUsernameEDMI -Value $LblAdminUsernameEDMI -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblAdminPasswordEDMI -Value $LblAdminPasswordEDMI -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminUsernameEDMI -Value $TxtAdminUsernameEDMI -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtAdminPasswordEDMI -Value $TxtAdminPasswordEDMI -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblSearchUser -Value $LblSearchUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtSearchUser -Value $TxtSearchUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name BtnCopyGroup -Value $BtnCopyGroup -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblPickUser -Value $LblPickUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name ListBoxPickUser -Value $ListBoxPickUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtBoxDisplayOutput -Value $TxtBoxDisplayOutput -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtBoxDisplayError -Value $TxtBoxDisplayError -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblNewUser -Value $LblNewUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtNewUser -Value $TxtNewUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblNewUserPassword -Value $LblNewUserPassword -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name TxtNewUserPassword -Value $TxtNewUserPassword -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblShow -Value $LblShow -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblOU -Value $LblOU -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name BtnGeneratePassword -Value $BtnGeneratePassword -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name BtnCreateUser -Value $BtnCreateUser -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name LblGroupsCopy -Value $LblGroupsCopy -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name ListBoxGroupsCopy -Value $ListBoxGroupsCopy -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name ChkUsernameSame -Value $ChkUsernameSame -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name ChkPasswordSame -Value $ChkPasswordSame -MemberType NoteProperty
Add-Member -InputObject $CreateUser -Name Exit -Value $Exit -MemberType NoteProperty
}
. InitializeComponent
