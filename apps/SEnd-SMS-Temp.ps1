$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$file = "$scriptPath" + "\TempHigh.txt"
Get-Content "$scriptPath\VariablesSMSBroadcast.txt" | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $token")
$TemperatureFile = "\\aubnebackup1.au.edmi.local\temperature\temp.txt"
$Temperature = [single]0
if ([System.IO.File]::Exists($TemperatureFile)) {
    $Temperature = [single](Get-Content $TemperatureFile).Substring(0,5)
    # Write-Host $TemperatureFile
    # Write-Host $Temperature
    # write-host "Value is $Message"
    if ($Temperature -gt 25) {
        if (![System.IO.File]::Exists($file)) { # Create file so you only send the SMS once
            $temp = New-Item -Path $file -ItemType File 
            $Message = "Server Room Temp is $Temperature"
            # write-host $Message
            $responsePeter = Invoke-RestMethod "http://api.smsbroadcast.com.au/api.php?username=$username&password=$password&from=$account&to=$Peter&message=$Message" -Method 'POST' -Headers $headers
            # $responsePeter | ConvertTo-Json
            # $responseScott = Invoke-RestMethod "http://api.smsbroadcast.com.au/api.php?username=$username&password=$password&from=$account&to=$Scott&message=$Message" -Method 'POST' -Headers $headers
            # $responseScott | ConvertTo-Json
        } 
    }
    else {
        if ([System.IO.File]::Exists($file)) { # Remove file so next time the temp goes high and sms can be sent
            $temp = Remove-Item -Path $file -Force
            # write-host "$file removed"
        }
    }
}