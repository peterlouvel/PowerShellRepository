<#
.SYNOPSIS
    Show the status of a service in a GUI
.DESCRIPTION
    Show the status of a service in a GUI
.EXAMPLE
    .\Show-Service
.NOTES
    General notes
#>

# Functions are at the top so the script engine won't complain about not knowing a funciton.
#region Functions
function MyFunction1 {
    $LblShow.Text = $LBoxPick.Text
    $TboxStatus.Text = (Get-Service -Name  $LBoxPick.Text).Status
}
#endregion Functions

#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
#endregion Variables

#region GUI

#region Form
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "Service Inspector"
$Form.TopMost                    = $true
#endregion Form

#region LblePick
$LblPick                         = New-Object system.Windows.Forms.Label
$LblPick.text                    = "Pick Service"
$LblPick.AutoSize                = $true
$LblPick.width                   = 25
$LblPick.height                  = 10
$LblPick.location                = '25,30'
$LblPick.Font                    = 'Microsoft Sans Serif,10'
#endregion LblePick

#region LblShow
$LblShow                        = New-Object system.Windows.Forms.Label
$LblShow.AutoSize               = $true
$LblShow.width                  = 25
$LblShow.height                 = 10
$LblShow.location               = '25,158'
$LblShow.Font                   = $Font
$LblShow.BorderStyle            = 1
#endregion LblShow

#region TboxStatus
$TboxStatus                     = New-Object system.Windows.Forms.Label
$TboxStatus.width               = 314
$TboxStatus.height              = 20
$TboxStatus.location            = '27,206'
$TboxStatus.Font                = $Font
$TboxStatus.BorderStyle         = 2
#endregion TboxStatus

#region LblCurrent
$LblCurrent                     = New-Object system.Windows.Forms.Label
$LblCurrent.text                = "Curent Status"
$LblCurrent.AutoSize            = $true
$LblCurrent.width               = 25
$LblCurrent.height              = 10
$LblCurrent.location            = '25,190'
$LblCurrent.Font                = $Font
#endregion LblCurrent

#region LBoxPick
$LBoxPick                       = New-Object System.Windows.Forms.ListBox
$LBoxPick.Width                 = 318
$LBoxPick.location              = '25,50'
$LBoxPick.Font                  = $Font
#endregion LBoxPick

$Form.controls.AddRange(@($LBoxPick,$LblPick,$TboxStatus,$LblCurrent,$LblShow))
#endregion GUI

#region LinkFunctions
$LBoxPick.Add_SelectedValueChanged({ MyFunction1 $this $_ })
#endregion LinkFunctions

# Put your code here
# $Servs = Get-Service -name Spooler | Select-Object -Property name
$Servs = Get-Service | Select-Object -Property name
$ItemsInBox = $Servs.Items.Count 
if ($ItemsInBox -ge 10 ) {
    $LBoxPick.Height = 18 * $NumberOfShownItems
} else {
    $LBoxPick.Height = 22 * ($ItemsInBox + 1)
}
$LBoxPick.Items.AddRange($Servs.name)




#Leave at the end of the script
[void]$Form.ShowDialog()