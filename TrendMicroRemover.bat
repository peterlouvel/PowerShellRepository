@echo off
setlocal enabledelayedexpansion
rem search TISTOOL ,if you want to search and delete other files .
set "FileName1=TISTOOL.exe"
set "FileName2=tis32.msi"
set "FileName3=TAVTOOL.exe"
set "FileName4=pcc.exe"
set "FileName5=PCClient.exe"
set "FileName6=tdiins.exe"
set "FileName7=UfNavi.exe"
set "FileName8=PCCTool.exe"
echo ......searching , please wait......
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if exist %%a:\ (
	rem search filename1, get the folder name then delete all files in the folder
    for /f "delims=" %%b in ('dir /a-d /s /b "%%a:\*%FileName1%" 2^>nul') do (
		if /i "%%~nxb" equ "%FileName1%" (
			echo get folder path:
			echo %%b > C:\TM.txt
			set c="%%~dpb"
			echo ......deleting the folder, please wait......
			rd /s /q !c!
			echo the !FileName1! and all files in same folder are deleted successfully......
		)
	)
	rem search filename2, get the folder name then delete all files in the folder	
    for /f "delims=" %%d in ('dir /a-d /s /b "%%a:\*%FileName2%" 2^>nul') do (
		if /i "%%~nxd" equ "%FileName2%" (
			echo get folder path:
			echo %%d > C:\TM1.txt
			set e="%%~dpd"
			echo deleting the folder,please wait...
			rd /s /q !e!
			echo the !FileName2! and all files in same folder are deleted successfully......
		)
    )
	rem search filename3, get the folder name then delete all files in the folder	
    for /f "delims=" %%k in ('dir /a-d /s /b "%%a:\*%FileName3%" 2^>nul') do (
		if /i "%%~nxk" equ "%FileName3%" (
			echo get folder path:
			echo %%k > C:\TM2.txt
			set l="%%~dpk"
			echo deleting the folder, please wait...
			rd /s /q !l!
			echo the !FileName3! and all files in same folder are deleted successfully......
		)
    )
	rem search filename4, get the folder name then delete all files in the folder	
    for /f "delims=" %%m in ('dir /a-d /s /b "%%a:\*%FileName4%" 2^>nul') do (
		if /i "%%~nxm" equ "%FileName4%" (
			echo get folder path:
			echo %%m > C:\TM3.txt
			set n="%%~dpm"
			echo deleting the folder, please wait...
			rd /s /q !n!
			echo the !FileName4! and all files in same folder are deleted successfully......
		)
    )
	rem search filename5, get the folder name then delete all files in the folder	
    for /f "delims=" %%o in ('dir /a-d /s /b "%%a:\*%FileName5%" 2^>nul') do (
		if /i "%%~nxo" equ "%FileName5%" (
			echo get folder path:
			echo %%o > C:\TM4.txt
			set p="%%~dpo"
			echo deleting the folder, please wait...
			rd /s /q !p!
			echo the !FileName5! and all files in same folder are deleted successfully......
		)
    )
	rem search filename6, get the folder name then delete all files in the folder	
    for /f "delims=" %%q in ('dir /a-d /s /b "%%a:\*%FileName6%" 2^>nul') do (
		if /i "%%~nxq" equ "%FileName6%" (
			echo get folder path:
			echo %%q > C:\TM5.txt
			set r="%%~dpq"
			echo deleting the folder, please wait...
			rd /s /q !r!
			echo the !FileName6! and all files in same folder are deleted successfully......
		)
    )
	rem search filename7, get the folder name then delete all files in the folder	
    for /f "delims=" %%s in ('dir /a-d /s /b "%%a:\*%FileName7%" 2^>nul') do (
		if /i "%%~nxs" equ "%FileName7%" (
			echo get folder path:
			echo %%s > C:\TM6.txt
			set t="%%~dps"
			echo deleting the folder, please wait...
			rd /s /q !t!
			echo the !FileName7! and all files in same folder are deleted successfully......
		)
    )
	rem search filename7, get the folder name then delete all files in the folder	
    for /f "delims=" %%u in ('dir /a-d /s /b "%%a:\*%FileName8%" 2^>nul') do (
		if /i "%%~nxu" equ "%FileName8%" (
			echo get folder path:
			echo %%u > C:\TM7.txt
			set v="%%~dpu"
			echo deleting the folder, please wait...
			rd /s /q !v!
			echo the !FileName8! and all files in same folder are deleted successfully......
		)
    )

  ) 
) 


copy  C:\TM.txt+C:\TM1.txt+C:\TM2.txt+C:\TM3.txt+C:\TM4.txt+C:\TM5.txt+C:\TM6.txt+C:\TM7.txt C:\OldTM.txt

del C:\TM.txt C:\TM1.txt C:\TM2.txt C:\TM3.txt C:\TM4.txt C:\TM5.txt C:\TM6.txt C:\TM7.txt


echo ......files has deleted successfully......
pause