@echo off
mkdir c:\temp 2> nul
SET DESKTOP_REG_ENTRY="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
SET DESKTOP_REG_KEY="Desktop"
SET DESKTOP_DIR="c:\users\public\desktop"
SET SCRIPTS=\\au.edmi.local\SYSVOL\au.edmi.local\scripts
FOR /F "tokens=1,2*" %%a IN ('REG QUERY %DESKTOP_REG_ENTRY% /v %DESKTOP_REG_KEY% ^| FINDSTR "REG_SZ"') DO (
    set DESKTOP_DIR="%%c"
)

if exist c:\windows\searchgroup.cmd (
	REM echo file exists
) else (
	if exist %scripts%\searchgroup.cmd (
		xcopy %scripts%\searchgroup.cmd c:\windows /y
	)
)

if exist \\fileserver.au.edmi.local\logininfo$\GetLoginInfo.txt (
	wmic bios get serialnumber > \\fileserver.au.edmi.local\logininfo$\Usernames\Serial\%username%_%computername%.txt
	systeminfo > \\fileserver.au.edmi.local\logininfo$\Usernames\SystemInfo\%username%_%computername%.txt
	wmic bios get serialnumber > \\fileserver.au.edmi.local\logininfo$\Computers\Serial\%computername%_%username%.txt
	systeminfo > \\fileserver.au.edmi.local\logininfo$\Computers\SystemInfo\%computername%_%username%.txt
)

if exist "%scripts%\Icons\IT Systems Information.url" (
	xcopy "%scripts%\Icons\IT Systems Information.url" %DESKTOP_DIR% /y
)

if exist "%scripts%\install-EDMI-vpn.ps1" (
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\install-EDMI-vpn.ps1
)

if exist "%scripts%\Add-Font.ps1" (
	xcopy %scripts%\Fonts2Install c:\temp\Fonts2Install /i /y
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\Add-Font.ps1 -path c:\temp\Fonts2Install
)

if exist "%USERPROFILE%\dpi.txt" (
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\DPI.ps1
	REM xcopy %scripts%\Files\QRes.exe c:\temp /y
	REM c:\temp\qres /x:1920 /y:1080
	xcopy %scripts%\Files\dc64cmd.exe c:\temp /y
	c:\temp\dc64cmd -width=1920 -height=1080 -monitor="\\.\DISPLAY3"
	rem del %USERPROFILE%\dpi.txt 
)

if exist c:\temp\AddToDomain.ps1 (
	del c:\temp\AddToDomain.ps1
)
if exist c:\temp\install.cmd (
	del c:\temp\install.cmd
)
if exist c:\temp\startup.cmd (
	del c:\temp\startup.cmd
)

