$SCRIPTS = "\\au.edmi.local\SYSVOL\au.edmi.local\scripts"
While (1) {
    if (Test-Path -Path "$Scripts\Files\ontop.ps1" -PathType Leaf) {
        Copy-Item "$Scripts\Files\ontop.ps1" -Destination "C:\temp"
    }
    & 'c:\temp\ontop.ps1'
}
