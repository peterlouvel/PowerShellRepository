###############################################################
# Get_Computer Last_Logon_v1.1.ps1
# Version 1.0
# Changelog : n/a
# MALEK Ahmed - 29 / 06 / 2017
###################

##################
#--------Config
##################

$domain = "au.edmi.local"

##################
#--------Main
##################

import-module activedirectory
$ErrorActionPreference = "SilentlyContinue"
cls
"The domain is " + $domain
$computername = Read-Host 'What is the computer name?'
"Processing the checks ..."
$myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$domaincontrollers = $myforest.Sites | % { $_.Servers } | Select Name
$RealComputerLastLogon = $null
$LastusedDC = $null
$domainsuffix = "*."+$domain
# write-host "$domainsuffix"
foreach ($DomainController in $DomainControllers) 
{
	# write-host "$DomainController"
	if ($DomainController.Name -like $domainsuffix)
	{
		$ComputerLastlogon = Get-ADComputer -Identity $computername -Properties LastLogon -Server $DomainController.Name
		# write-host "$ComputerLastLogon"
		if ($RealComputerLastLogon -le [DateTime]::FromFileTime($ComputerLastlogon.LastLogon))
		{
			$RealComputerLastLogon = [DateTime]::FromFileTime($ComputerLastlogon.LastLogon).tostring("dd-MMM-yyyy")
			$LastusedDC =  $DomainController.Name
			# write-host "**  $DomainController - $RealComputerLastLogon"
		}
	}
}
"The last logon occured the " + $RealComputerLastLogon + ""
"It was done against " + $LastusedDC + ""
Write-Host "............."
