Get-AdUser -Filter * -Properties * | Foreach {  
    Write-Host "" -nonewline
    if ($_.HomeDrive -ne $null) {
        if ($_.HomeDirectory.Contains('\\fileserver')) {
            Write-Host $_.HomeDrive  $_.HomeDirectory
            Set-AdUser -Credential $Cred -Identity $_.DistinguishedName -HomeDirectory $null -HomeDrive $null 
        }
    }
}