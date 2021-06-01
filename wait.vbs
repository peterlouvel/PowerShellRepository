on error resume next
Dim WshShell, blnOffice64, strOutlookPath
Set WshShell = WScript.CreateObject("WScript.Shell")
blnOffice64=False
blnOffice32=False
strOutlookPath=WshShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\outlook.exe\Path")

path = left(strOutlookPath,len(strOutlookPath)-1)
' wscript.echo path
directory = Right(path, Len(path) - InStrRev(path, "\"))
' wscript.echo directory


dteWait = DateAdd("s", 5, Now())
Do Until (Now() > dteWait)
Loop
' wscript.echo """c:\program files\Microsoft Office\Root\"&directory&"\outlook.exe"""
WshShell.Run """c:\program files\Microsoft Office\Root\"&directory&"\outlook.exe"""
WshShell.Run """c:\program files (x86)\Microsoft Office\Root\"&directory&"\outlook.exe"""