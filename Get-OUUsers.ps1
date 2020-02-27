# Get users of set OU
$OUpath = "ou=Gas,ou=Employees,ou=EDMI Singapore,dc=sg,dc=edmi,dc=local"
Get-ADUser -Filter * -SearchBase $OUpath -server "sg.edmi.local" | Select-object DistinguishedName,Name,UserPrincipalName 
$OUpath = "ou=Corporate Office,ou=Employees,ou=EDMI Singapore,dc=sg,dc=edmi,dc=local"
Get-ADUser -Filter * -SearchBase $OUpath -server "sg.edmi.local" | Select-object DistinguishedName,Name,UserPrincipalName 
