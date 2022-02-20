Function Button_Click()
{
    Stop-process -name chrome
    & "C:\Program Files\Google\Chrome\Application\chrome.exe" -incognito -kiosk -app=https://outlook.office.com/mail
 
}

# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

[void][reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
$ScreenSize = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize
$FormsBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

$formPrimary = New-Object System.Windows.Forms.Form
$formPrimary.Text = "Primary Form"
$formPrimary.StartPosition = 4
$formPrimary.ClientSize = "7,1"

$formPrimary.Topmost = $True
$formPrimary.MaximizeBox = $False
$formPrimary.MinimizeBox = $False
$formPrimary.ControlBox = $False
$formPrimary.FormBorderStyle = $FormsBorderStyle
$formPrimary.left = $ScreenSize.width - ($formPrimary.width * 10)
$formPrimary.top = -17
$formprimary.StartPosition = 0

$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(0,17)
$Button.Text = "Close"
$Button.Add_Click({Button_Click})
Button_Click
$formPrimary.Controls.Add($Button)
$formPrimary.ShowDialog()

