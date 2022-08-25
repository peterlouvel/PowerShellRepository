$s1 = New-PSSession -ComputerName "edmibneadfs1.edmi.local" -Credential $Cred 
Enter-PSSession $s1
powershell -noexit -executionpolicy bypass "c:\scripts\forceADsync.ps1"
start-sleep 5
