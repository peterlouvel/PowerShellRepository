@echo off
mkdir c:\temp 2> nul
SET DESKTOP_REG_ENTRY="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
SET DESKTOP_REG_KEY="Desktop"
SET DESKTOP_DIR="c:\temp"
SET SCRIPTS=\\au.edmi.local\SYSVOL\au.edmi.local\scripts
FOR /F "tokens=1,2*" %%a IN ('REG QUERY %DESKTOP_REG_ENTRY% /v %DESKTOP_REG_KEY% ^| FINDSTR "REG_SZ"') DO (
    set DESKTOP_DIR="%%c"
)

if not exist c:\windows\searchgroup.cmd (
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

if exist "%scripts%\Files\TeamViewer EDMI.exe" (
	xcopy "%scripts%\Files\TeamViewer EDMI.exe" %DESKTOP_DIR% /y
	rem %DESKTOP_DIR%\TeamViewerEDMI
)

if exist "%scripts%\install-EDMI-vpn.ps1" (
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\install-EDMI-vpn.ps1
)

if exist "%scripts%\Add-Font.ps1" (
	xcopy %scripts%\Fonts2Install c:\temp\Fonts2Install /i /y
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\Add-Font.ps1 -path c:\temp\Fonts2Install
)

if not exist c:\temp\FileExt1.txt (
	xcopy %scripts%\Files\SetUserFTA.exe c:\temp /y
	xcopy %scripts%\Files\fileExt.txt c:\temp\fileExt1.txt /y
	del c:\temp\fileExt.txt /q
	c:\temp\SetUserFTA c:\temp\FileExt1.txt
)

if exist "%USERPROFILE%\dpi.txt" (
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\DPI.ps1
	xcopy %scripts%\Files\dc64cmd.exe c:\temp /y
	c:\temp\dc64cmd -width=1920 -height=1080 -monitor="\\.\DISPLAY1"
)

if not exist c:\temp\SysPIN.exe (
	xcopy %scripts%\Files\SysPIN.exe c:\temp /y
)

if not exist %USERPROFILE%\taskbar.txt (
	c:\temp\SysPIN "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Mozilla Firefox\firefox.exe" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" "Pin to taskbar"
	xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\taskbar.txt /y
)


if exist c:\temp\AddToDomain.ps1 ( del c:\temp\AddToDomain.ps1 /q )
if exist c:\temp\install.cmd     ( del c:\temp\install.cmd /q )
if exist c:\temp\startup.cmd     ( del c:\temp\startup.cmd /q )
if exist "c:\users\public\desktop\TeamViewer EDMI.exe"  ( del "c:\users\public\desktop\TeamViewer EDMI.exe" /q )
if exist "c:\users\public\desktop\IT Systems Information.url"  ( del "c:\users\public\desktop\IT Systems Information.url" /q )
