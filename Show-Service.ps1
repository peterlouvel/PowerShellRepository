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
function MyFunction2 {
    $SearchFilter = '*' + $TxtFilter.Text + '*'
    $Servs = Get-Service -name $SearchFilter  | Select-Object -Property name
    #   $Servs = Get-Service | Select-Object -Property name
    $LBoxPick.Items.Clear()
    $ItemsInBox = $Servs.Items.Count 
    if ($ItemsInBox -ge ($NumberOfShownItems + 1) ) {
        $LBoxPick.Height = 16 * ($NumberOfShownItems + 1)
    } elseif ($ItemsInBox -ge 1) {
        $LBoxPick.Height = 16 * ($ItemsInBox + 1)
    } elseif ($ItemsInBox -eq 0){
        $LBoxPick.Height = 0
        return 
    } else { #can't show one item when height is below 20
        $LBoxPick.Height = 20
    }

    $LBoxPick.Items.AddRange($Servs.Name)
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
$LblTxtFilter                   = New-Object system.Windows.Forms.Label
$LblTxtFilter.text              = "Search for Service (filter box)"
$LblTxtFilter.AutoSize          = $true
$LblTxtFilter.width             = 25
$LblTxtFilter.height            = 10
$LblTxtFilter.location          = '25,10'
$LblTxtFilter.Font              = 'Microsoft Sans Serif,10'
#endregion LblePick

#region LblePick
$TxtFilter                      = New-Object System.Windows.Forms.TextBox
$TxtFilter.text                 = ""
$TxtFilter.width                = 314
$TxtFilter.height               = 10
$TxtFilter.location             = '25,30'
$TxtFilter.Font                 = 'Microsoft Sans Serif,10'
#endregion LblePick

#region LblePick
$LblPick                        = New-Object system.Windows.Forms.Label
$LblPick.text                   = "Pick Service"
$LblPick.AutoSize               = $true
$LblPick.width                  = 25
$LblPick.height                 = 10
$LblPick.location               = '25,60'
$LblPick.Font                   = 'Microsoft Sans Serif,10'
#endregion LblePick

#region LblShow
$LblShow                        = New-Object system.Windows.Forms.Label
$LblShow.AutoSize               = $true
$LblShow.width                  = 25
$LblShow.height                 = 10
$LblShow.location               = '25,188'
$LblShow.Font                   = $Font
$LblShow.BorderStyle            = 1
#endregion LblShow

#region TboxStatus
$TboxStatus                     = New-Object system.Windows.Forms.Label
$TboxStatus.width               = 314
$TboxStatus.height              = 20
$TboxStatus.location            = '27,236'
$TboxStatus.Font                = $Font
$TboxStatus.BorderStyle         = 2
#endregion TboxStatus

#region LblCurrent
$LblCurrent                     = New-Object system.Windows.Forms.Label
$LblCurrent.text                = "Curent Status"
$LblCurrent.AutoSize            = $true
$LblCurrent.width               = 25
$LblCurrent.height              = 10
$LblCurrent.location            = '25,220'
$LblCurrent.Font                = $Font
#endregion LblCurrent

#region LBoxPick
$LBoxPick                       = New-Object System.Windows.Forms.ListBox
$LBoxPick.Width                 = 318
$LBoxPick.location              = '25,80'
$LBoxPick.Font                  = $Font
#endregion LBoxPick

$Form.controls.AddRange(@($LblTxtFilter,$TxtFilter,$LBoxPick,$LblPick,$TboxStatus,$LblCurrent,$LblShow))
#endregion GUI

#region LinkFunctions
$LBoxPick.Add_SelectedValueChanged({ MyFunction1 $this $_ })
$TxtFilter.Add_TextChanged({ MyFunction2 $this $_ })

#endregion LinkFunctions

# Put your code here

MyFunction2



#Leave at the end of the script
[void]$Form.ShowDialog()