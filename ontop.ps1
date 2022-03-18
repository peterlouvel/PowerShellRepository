$numberButtons = 5
$buttonWidth = 110
$sizeWidth = $numberButtons * $buttonWidth
$global:runCount = 0
$Destination = "c:\users\$env:username\appdata\Local\Google"

# -incognito 

# --- functions ---------------------------------------------------------------------------
Function StopBrowser() {
    $chrome = Get-Process chrome -ErrorAction SilentlyContinue
    if ($chrome) {Stop-process -name chrome}
    Remove-Variable chrome
    Get-ChildItem -Path $Destination -Recurse | Remove-Item -force -recurse
}
Function ButtonOutlook_Click() {
    StopBrowser
    & "C:\Program Files\Google\Chrome\Application\chrome.exe" -kiosk -app=https://outlook.office.com
}
Function ButtonOkta_Click() {
    StopBrowser
    & "C:\Program Files\Google\Chrome\Application\chrome.exe" -kiosk -app=https://edmi.okta.com
}
Function ButtonWHS_Click() {
    StopBrowser
    & "C:\Program Files\Google\Chrome\Application\chrome.exe" -kiosk -app=http://whsrecorder.au.edmi.local/
}
Function ButtonPassword_Click() {
    StopBrowser
    & "C:\Program Files\Google\Chrome\Application\chrome.exe" -kiosk -app=https://adfs.edmi-meters.com/adfs/portal/updatepassword/
}
Function ButtonReboot_Click() {
    StopBrowser
    Restart-Computer -f 
}

# --- Form Setup --------------------------------------------------------------------------
[void][reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
$ScreenSize = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize
$FormsBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

$formPrimary = New-Object System.Windows.Forms.Form
$formPrimary.Text = "ontop"
$formPrimary.StartPosition = 4
$formPrimary.Size = "11,1"
$formPrimary.Topmost = $True
$formPrimary.MaximizeBox = $False
$formPrimary.MinimizeBox = $False
$formPrimary.ControlBox = $False
$formPrimary.FormBorderStyle = $FormsBorderStyle
$formPrimary.left = $ScreenSize.width - ($formPrimary.width + $sizeWidth) - 3
$formPrimary.top = -17
$formPrimary.width = $sizeWidth
$formprimary.StartPosition = 0

# --- Buttons -----------------------------------------------------------------------------
$ButtonNumber = 0
$ButtonOutlook = New-Object System.Windows.Forms.Button
$ButtonOutlook.Location = New-Object System.Drawing.Size(0,17)
$ButtonOutlook.Width = $buttonWidth
$ButtonOutlook.Left = $buttonWidth * $ButtonNumber
$ButtonOutlook.Text = "e-Mail"
$ButtonOutlook.Add_Click({ButtonOutlook_Click})
$formPrimary.Controls.Add($ButtonOutlook)

$ButtonNumber = 1
$ButtonOkta = New-Object System.Windows.Forms.Button
$ButtonOkta.Location = New-Object System.Drawing.Size(0,17)
$ButtonOkta.Width = $buttonWidth
$ButtonOkta.left = $buttonWidth * $ButtonNumber
$ButtonOkta.Text = "Okta"
$ButtonOkta.Add_Click({ButtonOkta_Click})
$formPrimary.Controls.Add($ButtonOkta)

$ButtonNumber = 2
$ButtonWHS = New-Object System.Windows.Forms.Button
$ButtonWHS.Location = New-Object System.Drawing.Size(0,17)
$ButtonWHS.Width = $buttonWidth
$ButtonWHS.left = $buttonWidth * $ButtonNumber
$ButtonWHS.Text = "Health && Safety"
$ButtonWHS.Add_Click({ButtonWHS_Click})
$formPrimary.Controls.Add($ButtonWHS)

$ButtonNumber = 3
$ButtonPassword = New-Object System.Windows.Forms.Button
$ButtonPassword.Location = New-Object System.Drawing.Size(0,17)
$ButtonPassword.Width = $buttonWidth
$ButtonPassword.left = $buttonWidth * $ButtonNumber
$ButtonPassword.Text = "Change Password"
$ButtonPassword.Add_Click({ButtonPassword_Click})
$formPrimary.Controls.Add($ButtonPassword)

$ButtonNumber = 4
$ButtonReboot = New-Object System.Windows.Forms.Button
$ButtonReboot.Location = New-Object System.Drawing.Size(0,17)
$ButtonReboot.Width = $buttonWidth
$ButtonReboot.left = $buttonWidth * $ButtonNumber
$ButtonReboot.Text = "Restart Computer"
$ButtonReboot.Add_Click({ButtonReboot_Click})
$formPrimary.Controls.Add($ButtonReboot)

ButtonOutlook_Click

$formPrimary.ShowDialog()
