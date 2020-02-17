@echo off
SET SOFTWARE="\\fileserver.au.edmi.local\Software"

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
