$User = "Test.uSer01"
$Title = "Software Developer (Contractor)"

$CopyUser = "BrendonV"
$CopyUserObject = Get-ADUser -Identity $CopyUser -Properties Department, physicalDeliveryOfficeName, Office, City, wWWHomePage, PostalCode, POBox, postOfficeBox, DistinguishedName

$UserOU = ($CopyUserObject.DistinguishedName -split ",",2)[1]


$UserLowerCase = $User.ToLower()
$Email = $UserLowerCase +"@edmi.com.au"
$NewUser = (Get-Culture).TextInfo.ToTitleCase($UserLowerCase) 

$FullNewUserName = $NewUser -replace '\.',' '

$Pos = $FullNewUserName.IndexOf(" ")
$GivenName = $FullNewUserName.Substring(0, $Pos)
$Surname = $FullNewUserName.Substring($Pos+1)

$paramsCreate = @{  Instance = "$CopyUserObject" 
                    Path = "$UserOU" 
                    Name = "$NewUser"
                    SamAccountName = "$UserLowerCase"
                    GivenName = "$GivenName" 
                    Surname = "$Surname" 
                    DisplayName = "$FullNewUserName"
                    UserPrincipalName = "$Email"
                    Department = "$CopyUserObject.Department" 
                    Office = "$CopyUserObject.Office"
                    physicalDeliveryOfficeName = "$CopyUserObject.Office"
                    City =  "$CopyUserObject.City"
                    PostalCode =  "$CopyUserObject.PostalCode"
                    POBox =  "$CopyUserObject.POBox"
                    postOfficeBox =  "$CopyUserObject.postOfficeBox"
                    Title = "$Title"
                    CN = "$FullNewUserName"
            }
New-ADUser  @paramsCreate -Credential $Cred 

# DisplayName, Name, CN             $FullNewUserName
# Title
# telephonenumber

# co                                Australia
# Country                           AU
# Country Code                      36
# Company                           EDMI Pty Ltd

$Cred = Get-Credential peterl_
$Session1 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edmibneexch1.edmi.local/powershell -Credential $Cred
Import-PSSession $Session1
Enable-Mailbox -Identity $UserLowerCase -Database "Mailbox Database Australian Users" -DomainController "AuBneDC11.au.edmi.local"
Exit-PSSession


$O365CREDS = Get-Credential "peter.louvel@edmi.com.au"
$Session2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $O365CREDS -Authentication Basic -AllowRedirection

Import-PSSession $Session2

New-MoveRequest -Identity $UserLowerCase -Remote -RemoteHostName "edmibneexch3.edmi.local" -TargetDeliveryDomain "edmi.mail.onmicrosoft.com" -RemoteCredential $Cred -DomainController "AuBneDC11.au.edmi.local"
# Manually create Migration of user mailbox as it's not working
# >Target user 'Stefan Mizzi' already has a primary mailbox.
# >    + CategoryInfo          : InvalidArgument: (Stefan.Mizzi@edmi.com.au:MailboxOrMailUserIdParameter) [New-MoveRequest], RecipientTaskException
# >    + FullyQualifiedErrorId : 8FA9E3FB,Microsoft.Exchange.Management.RecipientTasks.NewMoveRequest
# >    + PSComputerName        : edmibneexch1.edmi.local


Get-MoveRequest | Get-MoveRequestStatistics

Connect-MSOLService -CurrentCredential
# Remove-MsolUser –UserPrincipalName $NewUserMailBox"@edmi.com.au"
# Remove-MsolUser –UserPrincipalName $NewUserMailBox"@edmi.com.au" -RemoveFromRecycleBin
Get-ADUser $UserLowerCase | Set-MsolUser  -UsageLocation "AU"
Set-MsolUserLicense -UserPrincipalName $UserLowerCase"@edmi.com.au" -AddLicenses "EDMI:ENTERPRISEPACK" 