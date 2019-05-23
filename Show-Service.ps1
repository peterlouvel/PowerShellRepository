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

#region Variables
$NumberOfShownItems = 6
$Font               = 'Microsoft Sans Serif,10'
#endregion Variables

# Functions are at the top so the script engine won't complain about not knowing a funciton.
#region Functions
function MyFunction1{
    $LblShow.Text = $LBoxPick.Text
    $TboxStatus.Text = (Get-Service -Name  $LblShow.Text).Status
    if ($TboxStatus.Text -like "Running"){
        $BtnService.text = "Stop"
    } elseif ($TboxStatus.Text -like "Stopped"){
        $BtnService.text = "Start"
    }

}

function MyFunction2{
    $SearchFilter = '*' + $TxtFilter.Text + '*'
    $Servs = Get-Service -name $SearchFilter  | Select-Object -Property name
    #   $Servs = Get-Service | Select-Object -Property name
    $LBoxPick.Items.Clear()
    $ItemsInBox = $Servs.Length
    if ($ItemsInBox -ge ($NumberOfShownItems + 1) ){
        $LBoxPick.Height = 16 * ($NumberOfShownItems + 1)
    } elseif ($ItemsInBox -ge 1){
        $LBoxPick.Height = 16 * ($ItemsInBox + 1)
    } else { #can't show one item when height is below 20
        $LBoxPick.Height = 20
    }
    $LblPick.text = "Pick one of the "+($ItemsInBox+1)+" services"
    if ( $null -eq $Servs){

    }else{
        $LBoxPick.Items.AddRange($Servs.Name)
    }
}
function MyFunction3{
    $LblShow.Text 
    switch ($BtnService.text) {
        ('Stop')  { Stop-Service  -Name $LblShow.Text }
        ('Start') { Start-Service -Name $LblShow.Text }
        Default {}
    }
    $BtnService.text = "----"
    MyFunction1
}
#endregion Functions


#region GUI

#region Form
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                           = New-Object system.Windows.Forms.Form
$Form.ClientSize                = '400,400'
$Form.text                      = "Service Inspector"
$Form.TopMost                   = $true
#endregion Form

#region BtnService
$BtnService                     = New-Object System.Windows.Forms.Button
$BtnService.text                = "----"
$BtnService.width               = 90
$BtnService.height              = 30
$BtnService.location            = '25,280'
$BtnService.Font                = 'Microsoft Sans Serif,10'
#endregion BtnService

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

$Form.controls.AddRange(@($BtnService,$LblTxtFilter,$TxtFilter,$LBoxPick,$LblPick,$TboxStatus,$LblCurrent,$LblShow))
#endregion GUI

#region LinkFunctions
$LBoxPick.Add_SelectedValueChanged({ MyFunction1 $this $_ })
$TxtFilter.Add_TextChanged({ MyFunction2 $this $_ })
$BtnService.Add_Click({ MyFunction3 $this $_ })

#endregion LinkFunctions

# Put your code here

MyFunction2


#Leave at the end of the script
[void]$Form.ShowDialog()