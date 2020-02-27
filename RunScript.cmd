timeout 5 > nul
mkdir c:\temp

SET SOFTWARE=\\fileserver.au.edmi.local\Software
SET DESKTOP_REG_ENTRY="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
SET DESKTOP_REG_KEY="Desktop"
SET DESKTOP_DIR="c:\temp"
SET SCRIPTS=\\au.edmi.local\SYSVOL\au.edmi.local\scripts
FOR /F "tokens=1,2*" %%a IN ('REG QUERY %DESKTOP_REG_ENTRY% /v %DESKTOP_REG_KEY% ^| FINDSTR "REG_SZ"') DO (
    set DESKTOP_DIR="%%c"
)

@Reg Query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId | findstr /e /c:"1909"
@IF ERRORLEVEL 1 (
    Reg Query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId > \\fileserver.au.edmi.local\logininfo$\Computers\Ver\%computername%_%username%.txt
) else (
	del \\fileserver.au.edmi.local\logininfo$\Computers\Ver\%computername%*.txt /q
)

if not exist c:\windows\searchgroup.cmd (
	if exist %scripts%\searchgroup.cmd (
		xcopy %scripts%\searchgroup.cmd c:\windows /y
	)
)

rem --------------------------------------------------------------------------------------
for /f %%A in ('wmic csproduct get Vendor') do (
    if %%A==Dell goto Dell
    if %%A==LENOVO goto Lenovo
)

:notExist
    goto Continue
rem -----------------------------------------

:Dell
    goto Continue
rem -----------------------------------------

:Lenovo
    if not exist c:\drivers\apps\lenovo\setup_vantage.bat (
        xcopy /herky %SOFTWARE%\Lenovo c:\DRIVERS\APPS\Lenovo /i
        cmd /c call c:\drivers\apps\Lenovo\setup_vantage.bat
    )
	
    goto Continue
rem -----------------------------------------

:Continue
rem --------------------------------------------------------------------------------------


rem xcopy %scripts%\Files\Modules "C:\Program Files\WindowsPowerShell\Modules" /i /s /y

if exist \\fileserver.au.edmi.local\logininfo$\GetLoginInfo.txt (
	wmic bios get serialnumber > \\fileserver.au.edmi.local\logininfo$\Usernames\Serial\%username%_%computername%.txt
	systeminfo > \\fileserver.au.edmi.local\logininfo$\Usernames\SystemInfo\%username%_%computername%.txt
	wmic bios get serialnumber > \\fileserver.au.edmi.local\logininfo$\Computers\Serial\%computername%_%username%.txt
	systeminfo > \\fileserver.au.edmi.local\logininfo$\Computers\SystemInfo\%computername%_%username%.txt
)

if exist "%scripts%\Icons\IT Information.url" (
    if not exist "%DESKTOP_DIR%\IT Information.url" (
	    xcopy "%scripts%\Icons\IT Information.url" %DESKTOP_DIR% /y
    )
)

if exist "%scripts%\Files\TeamViewer EDMI.exe" (
    if not exist "%DESKTOP_DIR%\TeamViewer EDMI.exe" (
	    xcopy "%scripts%\Files\TeamViewer EDMI.exe" %DESKTOP_DIR% /y
	)
)

if exist "%scripts%\install-EDMI-vpn.ps1" (
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\install-EDMI-vpn.ps1
)

if exist "%scripts%\Add-Font.ps1" (
	xcopy %scripts%\Fonts2Install c:\temp\Fonts2Install /i /y
	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\Add-Font.ps1 -path c:\temp\Fonts2Install
)

if not exist %USERPROFILE%\FileExt1.txt (
	xcopy %scripts%\Files\SetUserFTA.exe c:\temp /y
	xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\fileExt1.txt* /y
	c:\temp\SetUserFTA %USERPROFILE%\FileExt1.txt
)
del c:\temp\fileExt.txt /q
if not exist %USERPROFILE%\taskbar.txt (
	if not exist c:\temp\SysPIN.exe (
		xcopy %scripts%\Files\SysPIN.exe c:\temp /y
	)
	c:\temp\SysPIN "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Mozilla Firefox\firefox.exe" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" "Pin to taskbar"
	c:\temp\SysPIN "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" "Pin to taskbar"
	xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\taskbar.txt* /y
)

if not exist %USERPROFILE%\OfficeUpgrade.txt (
	xcopy %scripts%\Files\OfficeUpgradeCDN.reg c:\temp\OfficeUpgradeCDN.reg* /y
	regedit /s c:\temp\OfficeUpgradeCDN.reg
	xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\OfficeUpgrade.txt* /y
)

if not exist %USERPROFILE%\SearchTopOff.txt (
	xcopy %scripts%\Files\SearchTop.reg c:\temp\SearchTop.reg* /y
	regedit /s c:\temp\SearchTop.reg
	xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\SearchTopOff.txt* /y
)

rem 
REM if exist "%USERPROFILE%\dpi.txt" (
REM 	powershell -ExecutionPolicy Bypass -noprofile -file %scripts%\DPI.ps1
REM 	xcopy %scripts%\Files\dc64cmd.exe c:\temp /y
REM 	c:\temp\dc64cmd -width=1920 -height=1080 -monitor="\\.\DISPLAY1"
REM 		if not exist %USERPROFILE%\NoReboot.txt (
REM 			xcopy %scripts%\Files\fileExt.txt %USERPROFILE%\NoReboot.txt* /y
REM 			shutdown /r /t 30 /c "The system needs to reboot."
REM 	)
REM )
if exist c:\temp\AddToDomain.ps1 ( del c:\temp\AddToDomain.ps1 /q )
if exist c:\temp\install.cmd     ( del c:\temp\install.cmd /q )
if exist c:\temp\startup.cmd     ( del c:\temp\startup.cmd /q )
if exist "c:\users\public\desktop\TeamViewer EDMI.exe"  ( del "c:\users\public\desktop\TeamViewer EDMI.exe" /q )
if exist "c:\users\public\desktop\IT Systems Information.url"  ( del "c:\users\public\desktop\IT Systems Information.url" /q )
