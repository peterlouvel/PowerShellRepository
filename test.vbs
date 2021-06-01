Dim WshShell, blnOffice64, strOutlookPath
Set WshShell = WScript.CreateObject("WScript.Shell")
blnOffice64=False
blnOffice32=False
strOutlookPath=WshShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\outlook.exe\Path")

Function FileExists(FilePath)
  Set fso = CreateObject("Scripting.FileSystemObject")
  ' wscript.echo FilePath
  If fso.FileExists(FilePath) Then
    FileExists=CBool(1)
  Else
    FileExists=CBool(0)
  End If
End Function

path = left(strOutlookPath,len(strOutlookPath)-1)
' wscript.echo path
directory = Right(path, Len(path) - InStrRev(path, "\"))
' wscript.echo directory
if WshShell.ExpandEnvironmentStrings("%PROCESSOR_ARCHITECTURE%") = "AMD64" then
  if FileExists("c:\program files (x86)\Microsoft Office\Root\"&directory&"\outlook.exe") then
    blnOffice32 = True
    wscript.echo "Office 32 installed on Win 64"
  end if
  if FileExists("c:\program files\Microsoft Office\Root\"&directory&"\outlook.exe") then
    blnOffice64=True
    wscript.echo "Office 64 installed on Win 64"
  end if
else
  if FileExists("c:\program files\Microsoft Office\Root\"&directory&"\outlook.exe") then
    blnOffice32=True
    wscript.echo "Office 32 installed on Win 32"
  end if
end if


