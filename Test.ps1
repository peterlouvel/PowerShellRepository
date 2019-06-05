$Username = "peterl_"

$passwordAU = "Nashua^edmi^01"
$SecureStringPwdAU = $passwordAU | ConvertTo-SecureString -AsPlainText -Force
$credAU = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdAU

$passwordNZ = "Nashua^edmi^01"
$SecureStringPwdNZ = $passwordNZ | ConvertTo-SecureString -AsPlainText -Force
$credNZ = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdNZ

$passwordEDMI = "Nashua^edmi^01"
$SecureStringPwdEDMI = $passwordEDMI | ConvertTo-SecureString -AsPlainText -Force
$credEDMI = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdEDMI

$passwordSG = "Nashua^edmi^01"
$SecureStringPwdSG = $passwordSG | ConvertTo-SecureString -AsPlainText -Force
$credSG = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $SecureStringPwdSG

$User = Get-ADUser -Identity test.user
$UserCopyFrom = Get-ADUser -Identity peter.louvel -Properties *

$counter = 0
foreach ($UserGroup in $UserCopyFrom.MemberOf) { 
    Write-Host $counter + " " + $UserGroup
    if ($UserGroup.Contains("DC=au")){
      $Server = "au.edmi.local"
      $cred = $credAU
    } elseif ($UserGroup.Contains("DC=nz")) {
      $Server = "nz.edmi.local"
      $cred = $credNZ
    } elseif ($UserGroup.Contains("DC=sg")) {
      $Server = "sg.edmi.local"
      $cred = $credSG
    } else {
      $Server = "edmi.local"
      $cred = $credEDMI
    }
    $Server
    try {
      
      Set-ADObject -Identity $UserGroup -Add @{"member"=$User.DistinguishedName} -Server $Server -Credential $cred
      Write-Host -ForegroundColor Green $server 
    } Catch {
      Write-Host -ForegroundColor Red "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
    }
    $counter++
}



if ($false) {
    
$TheUser = Get-ADUser -Identity test.user | Select-Object Distinguishedname
$UserCopyFrom = Get-ADUser -Identity peter.louvel -Properties memberof | Select-Object -ExpandProperty memberof 
$Group1 = [ADSI]"LDAP://au.edmi.local/$UserCopyFrom.MemberOf[2]"
$Group1.Add("LDAP://edmi.local/$TheUser")
$Group.setinfo()

Get-ADUser -Identity peter.louvel -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $TheUser -Server au.edmi.local -Credential peterl_
Get-ADUser -Identity peter.louvel -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $TheUser -Server edmi.local -Credential peterl_




Set-ADObject -Identity $UserCopyFrom[2] -Add @{"member"=$User.DistinguishedName} -Server edmi.local -Credential $cred

# Set-ADObject -Identity "CN=System Users Confluence,OU=global,OU=mail,OU=New Groups,OU=EDMI,DC=edmi,DC=local" -Add @{"member"=$User.DistinguishedName} -Server edmi.local -Credential edmi\peterl_




# Get-ADUser -Identity peter.louvel -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $TheUser -Server nz.edmi.local -Credential peterl_
# # Add-ADGroupMember -Identity "CN=Share Gas Administration (write),OU=Melbourne,OU=File Shares,OU=Permissions,OU=Groups,OU=EDMI Australia,DC=au,DC=edmi,DC=local" -members $TheUser
# $Group = Add-ADGroupMember -Server edmi.local -Credential peterl_ -Identity $UserCopyFrom.MemberOf[2] -members $TheUser 

# Try {
#   Set-ADObject -Identity $UserCopyFrom[2] -Add @{"member"=$TheUser.distinguishedName}
# } Catch {
#   Write-Host -ForegroundColor Red "[ERROR] $server - $($_.distinguishedName) - $($Error[0])"
# }



#    #Add-ADGroupMember -Server au.edmi.local -Credential peterl_ -Identity $Group1 -members $TheUser 
    
}
