
Function DigitToStrIPAddress($Digit9IPAddress) {
    $bin=[convert]::ToString([int32]$Digit9IPAddress,2).PadLeft(32,'0').ToCharArray()
    $A=[convert]::ToByte($bin[0..7] -join "",2)
    $B=[convert]::ToByte($bin[8..15] -join "",2)
    $C=[convert]::ToByte($bin[16..23] -join "",2)
    $D=[convert]::ToByte($bin[24..31] -join "",2)
    return $($A,$B,$C,$D -join ".")
   }
   
   $all = @()
      
   $users = get-aduser -filter * -Properties 'msRADIUSFramedIPAddress' | Where-Object { $_.msRADIUSFramedIPAddress -ne $null }
   foreach( $user in $users)
   {
       $IP = DigitToStrIPAddress($user.msRADIUSFramedIPAddress)
       $result = new-object psobject
       $result | add-member noteproperty sAMAccountName $user.SamAccountName
       $result | add-member noteproperty IP $IP
   
       $all += $result
   }
   
   
   $all | export-csv c:\temp\results.csv -encoding UTF8
   
   
   