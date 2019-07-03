$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Button]$btn = $null
[System.Windows.Forms.Label]$lblmessage = $null
[System.Windows.Forms.TextBox]$txtmessage = $null
function InitializeComponent
{
$btn = (New-Object -TypeName System.Windows.Forms.Button)
$lblmessage = (New-Object -TypeName System.Windows.Forms.Label)
$txtmessage = (New-Object -TypeName System.Windows.Forms.TextBox)
$form1.SuspendLayout()
#
# lblmessage
#
$lblmessage.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]10))
$lblmessage.Name = [System.String]'lblmessage'
$lblmessage.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$lblmessage.TabIndex = 1
$lblmessage.Text = 'message'
$lblmessage.UseCompatibleTextRendering = $true
#
# txtmessage
#
$txtmessage.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]120,[System.Int32]10))
$txtmessage.Name = [System.String]'txtmessage'
$txtmessage.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]200,[System.Int32]23))
$txtmessage.TabIndex = 2
#
# btn
#
$btn.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]220,[System.Int32]40))
$btn.Name = [System.String]'btn'
$btn.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$btn.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$btn.TabIndex = 3
$btn.Text = 'Submit'
$btn.UseVisualStyleBackColor = $true
$btn.add_Click($btn_Click)
$Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]380,[System.Int32]90))
$Form1.Controls.Add($lblmessage)
$Form1.Controls.Add($txtmessage)
$Form1.Controls.Add($btn)
$Form1.Text = [System.String]'Form1'
$Form1.ResumeLayout($true)
Add-Member -InputObject $Form1 -Name btn -Value $btn -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name lblmessage -Value $lblmessage -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name txtmessage -Value $txtmessage -MemberType NoteProperty
}
. InitializeComponent
