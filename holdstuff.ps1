
# $file = "ontop"
# $fileLocation = "\\au.edmi.local\SYSVOL\au.edmi.local\scripts\Files\"
# $filePS = $fileLocation + $file + ".ps1"
# $fileVB = $fileLocation + $file + "1.vbs"
# Function UpdateOntop() {
#     if (Test-Path -Path $filePS -PathType Leaf)  {Copy-Item $filePS "c:\temp" -force}
#     # if (Test-Path -Path $fileVB -PathType Leaf)  {Copy-Item $fileVB "c:\temp" -force}
# }

# Function CloseOntop($Number) {
#     if ($global:runCount -ne 0){
#         # $notify.visible = $true
#         # $notify.showballoontip(10,'','ok',[system.windows.forms.tooltipicon]::None)
#         & "C:\Windows\System32\cscript.exe" "C:\temp\ontop2.vbs //nologo //b $Number"
#         Stop-Process -Id $PID
#     }
#     $global:runCount = $global:runCount + 1
# }
# [void][reflection.assembly]::loadwithpartialname("System.Drawing") 
# $notify = New-Object System.Windows.forms.notifyicon
# $notify.icon = [System.Drawing.SystemIcons]::Information