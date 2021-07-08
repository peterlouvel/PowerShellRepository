
$machines = Get-ADComputer -SearchBase "DC=au,DC=edmi,DC=local"  -Filter 'Name -like "AuBne*"' | Select-Object -ExpandProperty DNSHostname
 foreach ($machine in $machines) { Invoke-Command -Computer $machine -ScriptBlock {(Stop-Service -Name Spooler -Force), (Set-Service -Name Spooler -StartupType Disabled) , (Get-Service -Name Spooler)} }