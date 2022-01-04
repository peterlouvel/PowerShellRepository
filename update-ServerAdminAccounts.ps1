$ServerList = Get-ADComputer -filter 'Name -like "Aumel*"' -Properties Name, OperatingSystem | Select-Object Name,OperatingSystem | where-object {$_.OperatingSystem -like "Windows Server 201*" } | Select-Object Name | Sort-Object Name

foreach ($ServerinList in $ServerList.Name) {
    write-host $ServerinList
    .\Create-CredmanServerPassword.ps1 -ServerName $ServerinList -UserName "LocalAdmin"
}
