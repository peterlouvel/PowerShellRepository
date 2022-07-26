# Get a list of all computer objects and OS
# Get-ADComputer -filter * -Properties * | Format-Table Name, OperatintSystem -wrap -AutoSize

#Backup all GPO
$date = Get-Date -Format yyyMMdd
# New-Item -Path "c:\temp\GPO_Backup" -ItemType "Directory"
$directory = "C:\temp\GPO_Backup\$date"
New-Item -Path "$directory" -ItemType "Directory"
$GPOs = get-gpo -All | sort -Property "DisplayName" | Select-Object "DisplayName"  
foreach ($GPO in $GPOs) {
    New-Item -Path "$directory\$GPO" -ItemType "Directory"
    Backup-GPO -Name $GPO.DisplayName -Path "$directory\$GPO"
}

#Create Group Policy Objects
# New-GPO -Name "Mater S 1" -Domain "domain"
