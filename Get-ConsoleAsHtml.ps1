<###########################################################################################################
 Get-ConsoleAsHtml.ps1

 The script captures console screen buffer up to the current cursor position and returns it in HTML format.

 Returns: UTF8-encoded string.

 Example:

 $htmlFileName = "$env:temp\ConsoleBuffer.html"
 .\Get-ConsoleAsHtml | out-file $htmlFileName -encoding UTF8
 $null = [System.Diagnostics.Process]::Start("$htmlFileName")

##########################################################################################################>

# Check the host name and exit if the host is not the Windows PowerShell console host.
if ($host.Name -ne 'ConsoleHost'){
  write-host -ForegroundColor Red "This script runs only in the console host. You cannot run this script in $($host.Name)."
  exit -1
}
# The Windows PowerShell console host redefines DarkYellow and DarkMagenta colors and uses them as defaults.
# The redefined colors do not correspond to the color names used in HTML, so they need to be mapped to digital color codes.
#
$htmlFileName = "$env:temp\ConsoleBuffer.html"
function Normalize-HtmlColor ($color){
  if ($color -eq "DarkYellow") { $color = "#eeedf0" }
  if ($color -eq "DarkMagenta") { $color = "#012456" }
  return $color
}
# Create an HTML span from text using the named console colors.
#
function Make-HtmlSpan ($text, $forecolor = "DarkYellow", $backcolor = "DarkMagenta"){
  $forecolor = Normalize-HtmlColor $forecolor
  $backcolor = Normalize-HtmlColor $backcolor
  # You can also add font-weight:bold tag here if you want a bold font in output.
  return "<span style='font-family:Courier New;color:$forecolor;background:$backcolor'>$text</span>"
}
# Generate an HTML span and append it to HTML string builder
#
function Append-HtmlSpan{
  $spanText = $spanBuilder.ToString()
  $spanHtml = Make-HtmlSpan $spanText $currentForegroundColor $currentBackgroundColor
  $null = $htmlBuilder.Append($spanHtml)
}
# Append line break to HTML builder
#
function Append-HtmlBreak{
  $null = $htmlBuilder.Append("<br>")
}

# Initialize the HTML string builder.
$htmlBuilder = new-object system.text.stringbuilder
$null = $htmlBuilder.Append("<pre style='MARGIN: 0in 10pt 0in;line-height:normal';font-size:10pt>")
# Grab the console screen buffer contents using the Host console API.
$bufferWidth = $host.ui.rawui.BufferSize.Width
$bufferHeight = $host.ui.rawui.CursorPosition.Y
$rec = new-object System.Management.Automation.Host.Rectangle 0,0,($bufferWidth - 1),$bufferHeight
$buffer = $host.ui.rawui.GetBufferContents($rec)
# Iterate through the lines in the console buffer.
for($i = 0; $i -lt $bufferHeight; $i++){
  $spanBuilder = new-object system.text.stringbuilder
  # Track the colors to identify spans of text with the same formatting.
  $currentForegroundColor = $buffer[$i, 0].Foregroundcolor
  $currentBackgroundColor = $buffer[$i, 0].Backgroundcolor
  for($j = 0; $j -lt $bufferWidth; $j++){
    $cell = $buffer[$i,$j]
    # If the colors change, generate an HTML span and append it to the HTML string builder.
    if (($cell.ForegroundColor -ne $currentForegroundColor) -or ($cell.BackgroundColor -ne $currentBackgroundColor)){
      Append-HtmlSpan
      # Reset the span builder and colors.
      $spanBuilder = new-object system.text.stringbuilder
      $currentForegroundColor = $cell.Foregroundcolor
      $currentBackgroundColor = $cell.Backgroundcolor
    }
    # Substitute characters which have special meaning in HTML.
    switch ($cell.Character){
      '>' { $htmlChar = '&gt;' }
      '<' { $htmlChar = '&lt;' }
      '&' { $htmlChar = '&amp;' }
      default{
        $htmlChar = $cell.Character
      }
    }
    $null = $spanBuilder.Append($htmlChar)
  }
  Append-HtmlSpan
  Append-HtmlBreak
}
# Append HTML ending tag.
$null = $htmlBuilder.Append("</pre>")
return $htmlBuilder.ToString()  | out-file $htmlFileName -encoding UTF8
# start chrome $htmlFileName



# SIG # Begin signature block
# MIITzAYJKoZIhvcNAQcCoIITvTCCE7kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdUPujupVTcMji/W0c8z8MCr5
# UF2gghEqMIIEVjCCAz6gAwIBAgIKJjdc9gABAAAACTANBgkqhkiG9w0BAQsFADAe
# MRwwGgYDVQQDExNFRE1JIEdsb2JhbCBSb290IENBMB4XDTE2MTAyMDAzMDMwOVoX
# DTI2MTAyMDAzMTIwMlowRjEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZIm
# iZPyLGQBGRYEZWRtaTEXMBUGA1UEAxMORURNSSBHbG9iYWwgQ0EwggEiMA0GCSqG
# SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxKFzVMCqwmEw3OIqQf6VUwr3k5MZ0XucN
# FKLfVkahyUztXIhQwwNsnW+HjclzgDTewY/2qtXobECA4H+wibB0c6roSuUx3ZU5
# wXd7E5fjWGmFw7Oh4vk4LAwckWeeMXvQ1qPZSExQlV5+EU+VMhk4w/d87Z2afZ+9
# tFBnt6WApmzRXB/rMAyUlOOI7I9Bycd9BbfBEDYSy61tjMfnzY61a93WIm1oABSk
# 3W5U3KAhaoZrK5e077+dK7AhPYELxpC+qSzSsu0wYXuCTahE+dScRa5jxcCpRfuZ
# KfS/H001cPHBG3+cExrD5hV8scKf6LP6VVnt6NGihp8VnwGEgM6TAgMBAAGjggFs
# MIIBaDASBgkrBgEEAYI3FQEEBQIDAgACMCMGCSsGAQQBgjcVAgQWBBS6fmJZtj8/
# qU+H54dqRMC/EJlOOTAdBgNVHQ4EFgQUOl46QWE+W8BE0z8nl7VwNJwa2SQwGQYJ
# KwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQF
# MAMBAf8wHwYDVR0jBBgwFoAUfprvQO8VTOW2HfMHBTHdUVvgMBcwTgYDVR0fBEcw
# RTBDoEGgP4Y9aHR0cDovL2VkbWlibmVjYTIvQ2VydEVucm9sbC9FRE1JJTIwR2xv
# YmFsJTIwUm9vdCUyMENBKDEpLmNybDBkBggrBgEFBQcBAQRYMFYwVAYIKwYBBQUH
# MAKGSGh0dHA6Ly9lZG1pYm5lY2EyL0NlcnRFbnJvbGwvRWRtaUJuZUNhMV9FRE1J
# JTIwR2xvYmFsJTIwUm9vdCUyMENBKDEpLmNydDANBgkqhkiG9w0BAQsFAAOCAQEA
# NfPi4ztI4jZ+MmGSC3kA7djlqyhgwcLqHRway2VcV3UmQjJ0sdbuK6mTrJlFsXv4
# JQmp27f0PEksHR8wyLZ7x1EM6N2EREZ7mbArOiuHiRa7UwNBFFwexRigIaugfcNb
# y28rm0st6rOEjV5nYE6sxuK0XUG13a+bBHBMZW/U2dgx4xkfyloXn69xNbrvsLeP
# YlijjN+JzqSBfVMe7JD54bCsG9J4sDimvBOHbp5mTzKnnVbqZEuGuyCPNRiB/oWM
# LtmR/0pdK8FOEJDFW521MkGODrJloGf9xNLGMC7nkWLUbprD91gLVUwMb70mg8Yt
# 1yMSxilRQFGK/Yl7MCiGADCCBckwggSxoAMCAQICCiZqAPMAAgAAAJAwDQYJKoZI
# hvcNAQELBQAwRjEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZImiZPyLGQB
# GRYEZWRtaTEXMBUGA1UEAxMORURNSSBHbG9iYWwgQ0EwHhcNMTgxMDE4MDQwMzM2
# WhcNMjAxMDE4MDQxMzM2WjBdMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFDASBgoJ
# kiaJk/IsZAEZFgRlZG1pMRIwEAYKCZImiZPyLGQBGRYCYXUxGjAYBgNVBAMTEUVE
# TUkgQXVzdHJhbGlhIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# yNNMtmVcvPY6LoD/IJWZWRjaxI6JlhPqBNJMnMj9j4jiQaxm4imIe2MOcY0DbwAv
# AjadRgejwYDiEBMUbnwvWoLz7wRln073esPV5Mh18phiolD9vg29+vRPiarfJp36
# 4uD/Bhg9fASSQhNv7a+zJ+HgIGFsfdyF6VXnH+SRbTkLUsq031wo+E6FREVnQl1h
# 9oSafMWzP2gP94qRJHVgS716shAEV7VfhIq/EJkBXNJsMa/ofn5nddAf8DXLr5zq
# MLukAzl9CagHUODUlHzKHr4gZJyUxuXTukOjHCQdz2QBmMuq7bkRve8Qtx8b7RNN
# LD0IDf3Jlhk/Nn+0i05ZCwIDAQABo4ICoDCCApwwEgYJKwYBBAGCNxUBBAUCAwcA
# BzAjBgkrBgEEAYI3FQIEFgQUgqN+VVWyeitcIdezHBrw0aICQ00wHQYDVR0OBBYE
# FA0Sro/h/iMgoD3AujZxJxwVU2QhMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBB
# MA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFDpe
# OkFhPlvARNM/J5e1cDScGtkkMIIBHQYDVR0fBIIBFDCCARAwggEMoIIBCKCCAQSG
# gb5sZGFwOi8vL0NOPUVETUklMjBHbG9iYWwlMjBDQSgyKSxDTj1FZG1pQm5lQ2Ey
# LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxD
# Tj1Db25maWd1cmF0aW9uLERDPWVkbWksREM9bG9jYWw/Y2VydGlmaWNhdGVSZXZv
# Y2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50
# hkFodHRwOi8vZWRtaWJuZWNhMi5lZG1pLmxvY2FsL0NlcnRFbnJvbGwvRURNSSUy
# MEdsb2JhbCUyMENBKDIpLmNybDCBwwYIKwYBBQUHAQEEgbYwgbMwgbAGCCsGAQUF
# BzAChoGjbGRhcDovLy9DTj1FRE1JJTIwR2xvYmFsJTIwQ0EsQ049QUlBLENOPVB1
# YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
# b24sREM9ZWRtaSxEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xh
# c3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTANBgkqhkiG9w0BAQsFAAOCAQEAPiH9
# Z22TppVqMbMF3xI7VZiCwslS1kvw3KoBJ4QYnYQlzaIuA/UCdm25zatxlkAJVXeq
# ZusrDfFovQXKFr0zp+ELIgGlWBIAeWcc6qR5steCxn8T+ydDSDH39apShdrdMbM9
# k+SCQxAXzEXo+5n9Pmh5mWxFEkN/uBE13ZqSTWq+YgzouRMDgQ+GXvWT4+eljS3P
# LU2gxnHGZcT3T33S1gJ+/nKYdBrp0S56/S4NRT3mWQYL5OZ6MRM+yYe9a4cXZOm3
# BcMYWLExUyJz8MxinX39Y22drvtu5XXL7vZANFnDD/jihLd9koqDS8e24om5OFIJ
# R5matxGYZbRMUDQmQTCCBv8wggXnoAMCAQICCkj1kl8ABwAAU38wDQYJKoZIhvcN
# AQELBQAwXTEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRQwEgYKCZImiZPyLGQBGRYE
# ZWRtaTESMBAGCgmSJomT8ixkARkWAmF1MRowGAYDVQQDExFFRE1JIEF1c3RyYWxp
# YSBDQTAeFw0xOTEwMDMwMzE1MThaFw0yMDEwMDIwMzE1MThaMIHFMRUwEwYKCZIm
# iZPyLGQBGRYFbG9jYWwxFDASBgoJkiaJk/IsZAEZFgRlZG1pMRIwEAYKCZImiZPy
# LGQBGRYCYXUxFzAVBgNVBAsTDkVETUkgQXVzdHJhbGlhMRIwEAYDVQQLEwlFbXBs
# b3llZXMxFDASBgNVBAsTC0JyaXNiYW5lIEhRMRkwFwYDVQQLExBCdXNpbmVzcyBT
# eXN0ZW1zMQ0wCwYDVQQLEwRUZXN0MRUwEwYDVQQDEwxQZXRlciBMb3V2ZWwwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDJYdqwVBSpud/sYG7eZapLpeoh
# PP9TVPuirIt+OtXpW4Qm4Qp95r/bEFUBiVTU4EGwSe0plhqgkpWWqjrR3ftVrK6a
# AYkuPsXEyTeRoLmohOHpeMuBiq+0BY3+skzwtc/VJVzaTiNVaTi9w8NLsgum/kgJ
# eh9uWXAuu/RSlHFBxAUxAAT4kZfcmWWb4Ff+5zGKcITJNIDnBkTeAGqSz7p8pp/y
# aQFAJwy/VOSwGrSiLd3Op/Xw3rwa1+A8OVLl8DJsfC+JIZllZowKeKUDS0wO/oLS
# xli4sU0O0FP68p0fRqsIwzq3Z4R/7mxrbpnREpLiEmyanB4z97VfHnyo+WvpAgMB
# AAGjggNWMIIDUjA9BgkrBgEEAYI3FQcEMDAuBiYrBgEEAYI3FQiHt4wonIQfhaGb
# F4SRo3yGzulvgTyG9bBAhoyySwIBZQIBBjATBgNVHSUEDDAKBggrBgEFBQcDAzAO
# BgNVHQ8BAf8EBAMCB4AwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAzBgNV
# HREELDAqoCgGCisGAQQBgjcUAgOgGgwYcGV0ZXIubG91dmVsQGVkbWkuY29tLmF1
# MB0GA1UdDgQWBBRytQT/aCG4GvJyTDRpkk3MgOFJWzAfBgNVHSMEGDAWgBQNEq6P
# 4f4jIKA9wLo2cSccFVNkITCCASIGA1UdHwSCARkwggEVMIIBEaCCAQ2gggEJhoG/
# bGRhcDovLy9DTj1FRE1JJTIwQXVzdHJhbGlhJTIwQ0EoNyksQ049QXVCbmVDYTEs
# Q049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENO
# PUNvbmZpZ3VyYXRpb24sREM9ZWRtaSxEQz1sb2NhbD9jZXJ0aWZpY2F0ZVJldm9j
# YXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSG
# RWh0dHA6Ly9hdWJuZWNhMS5hdS5lZG1pLmxvY2FsL0NlcnRFbnJvbGwvRURNSSUy
# MEF1c3RyYWxpYSUyMENBKDcpLmNybDCCATIGCCsGAQUFBwEBBIIBJDCCASAwgbMG
# CCsGAQUFBzAChoGmbGRhcDovLy9DTj1FRE1JJTIwQXVzdHJhbGlhJTIwQ0EsQ049
# QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
# bmZpZ3VyYXRpb24sREM9ZWRtaSxEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/
# b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTBoBggrBgEFBQcwAoZc
# aHR0cDovL2F1Ym5lY2ExLmF1LmVkbWkubG9jYWwvQ2VydEVucm9sbC9BdUJuZUNh
# MS5hdS5lZG1pLmxvY2FsX0VETUklMjBBdXN0cmFsaWElMjBDQSg3KS5jcnQwDQYJ
# KoZIhvcNAQELBQADggEBAJDfa8rvsUPxNj2EokwSuS9Lq9Qm4u65BzatRNbbi3Wl
# IPgbTp0xfQAVYteM4ke/9r+rStd3clIF+PPn/R7QyzB4kKQGMQ5MM5i+QU/0gA/7
# sUds1+4KJSqrr6v9qv/cyjZMjzbQJ0TxMGND1G2TyqS1No/Y8yg/UsndbwHbbFa7
# V+IV50Z8luJP4FdiVT3QifuZ2Oub/WP6ELyglHk0jhPUOgJviP0q9TmCzgb58gs/
# OSZ4UYzM4SnSQ2NwBSvyc/aT735VC8nmBZSe63ZkiVImpg3XBSQ9Aj0qiYolkFdL
# 427a2NwriZIZa8YzV09zMFqhkBMW6Wea2BZqzm0Zt/8xggIMMIICCAIBATBrMF0x
# FTATBgoJkiaJk/IsZAEZFgVsb2NhbDEUMBIGCgmSJomT8ixkARkWBGVkbWkxEjAQ
# BgoJkiaJk/IsZAEZFgJhdTEaMBgGA1UEAxMRRURNSSBBdXN0cmFsaWEgQ0ECCkj1
# kl8ABwAAU38wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAw
# GQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
# AQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFOeTvTFVIHwoaAHuKWxplqfdlAYJMA0G
# CSqGSIb3DQEBAQUABIIBAJw+xzdgwXys7jhy3yFf77DYlWEGoGUF5vdCEpFCZDe4
# YEf+0/oCPwjck9FMyPBrDd/hXlbSfiMU6HV3EE+5nL4H3Mu/rwW2qaCh67zGVR90
# 91X8B7hdfnmxzYPp+5KEoyOF/bHUX2kM/FpWCwfcMfDSWthPna6K9FXnk+JLm9SR
# HkhqyI85G6ratbUK/1tGE4dboGv73S7sk+2BKjoF6esfgN1c9Zq4CxTiQJBrM3mL
# MAwgcEpmWSpRSPBkSdToYbMuDdf7mu+KzFMVK8qp/l14Pxi43wtt9IAc+Xu04os5
# tqEZ28hgef/2dqYdVcvGY7Tt35VKrwev7xvs7+sSsJQ=
# SIG # End signature block
