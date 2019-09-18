c:
cd \scripts
rem Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

rem powershell -executionpolicy bypass c:\scripts\wol-adsync.ps1 > c:\scripts\wol-adsync.txt


powershell -executionpolicy bypass  c:\scripts\WOL-BrisbaneHQ.ps1 > c:\scripts\WOL-DoneHQ.txt
powershell -executionpolicy bypass  c:\scripts\WOL-Brendale.ps1 > c:\scripts\WOL-DoneSD.txt
powershell -executionpolicy bypass  c:\scripts\WOL-Melbourne.ps1 > c:\scripts\WOL-DoneMEL.txt
powershell -executionpolicy bypass  c:\scripts\WOL-NZ.ps1 > c:\scripts\WOL-NZ.txt