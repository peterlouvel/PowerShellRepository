<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 
  
$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "Service Inspector"
$Form.TopMost                    = $false

$LBoxPick                        = New-Object System.Windows.Forms.ComboBox

$LBoxPick.width                  = 318
$LBoxPick.height                 = 30
$LBoxPick.location               = New-Object System.Drawing.Point(24,62)


$LblPick                         = New-Object system.Windows.Forms.Label
$LblPick.text                    = "Pick Service"
$LblPick.AutoSize                = $true
$LblPick.width                   = 25
$LblPick.height                  = 10
$LblPick.location                = New-Object System.Drawing.Point(30,34)
$LblPick.Font                    = 'Microsoft Sans Serif,10'

# $BtnCheckSvc                     = New-Object system.Windows.Forms.Button
# $BtnCheckSvc.text                = "Check Service"
# $BtnCheckSvc.width               = 111
# $BtnCheckSvc.height              = 30
# $BtnCheckSvc.location            = New-Object System.Drawing.Point(231,111)
# $BtnCheckSvc.Font                = 'Microsoft Sans Serif,10'

$LblShow                         = New-Object system.Windows.Forms.Label
$LblShow.text                    = ""
$LblShow.AutoSize                = $true
$LblShow.width                   = 25
$LblShow.height                  = 10
$LblShow.location                = '27,176'
$LblShow.Font                    = 'Microsoft Sans Serif,10'


$TboxStatus                      = New-Object system.Windows.Forms.TextBox
$TboxStatus.multiline            = $false
$TboxStatus.width                = 314
$TboxStatus.height               = 20
$TboxStatus.location             = '27,196'
$TboxStatus.Font                 = 'Microsoft Sans Serif,15'

$LblCurrent                      = New-Object system.Windows.Forms.Label
$LblCurrent.text                 = "Curent Status"
$LblCurrent.AutoSize             = $true
$LblCurrent.width                = 25
$LblCurrent.height               = 10
$LblCurrent.location             = New-Object System.Drawing.Point(30,153)
$LblCurrent.Font                 = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($LBoxPick,$LblPick,$BtnCheckSvc,$TboxStatus,$LblCurrent))

#region gui events {
#$BtnCheckSvc.Add_Click({ Click_status_button })
$LBoxPick. ({ Click_SelectBox })



#endregion events }

#endregion GUI }
$Servs = Get-Service | Select-Object -Property name
$LBoxPick.Items.AddRange($Servs.name)
$LBoxPick.Text = $Servs[0].name

#Write your logic code here
 
function Click_status_button {
       
}

function Click_SelectBox {
    
    Write-Host "Selected: " $LBoxPick.Text
     
 }

[void]$Form.ShowDialog()