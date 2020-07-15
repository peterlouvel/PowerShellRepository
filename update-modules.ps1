$O365Modules = @("MicrosoftTeams", "MSOnline", "AzureAD", "ExchangeOnlineManagement", "Microsoft.Online.Sharepoint.PowerShell", "ORCA")
ForEach ($Module in $O365Modules) {
    Write-Host "Checking and updating module" $Module
    Install-Module $Module -Force  -Scope AllUsers
}  
ForEach ($Module in $O365Modules) {
    Write-Host "Checking for older versions of" $Module -foregroundcolor Green
    $AllVersions = Get-InstalledModule -Name $Module -AllVersions
    $AllVersions = $AllVersions | Sort PublishedDate -Descending 
    $MostRecentVersion = $AllVersions[0].Version
    Write-Host "Most recent version of" $Module "is" $MostRecentVersion "published on" (Get-Date($AllVersions[0].PublishedDate) -format g)
    If ($AllVersions.Count -gt 1 ) { # More than a single version installed
       ForEach ($Version in $AllVersions) { #Check each version and remove old versions
         If ($Version.Version -ne $MostRecentVersion)  { # Old version - remove
            Write-Host "Uninstalling version" $Version.Version "of Module" $Module -foregroundcolor Red 
            Uninstall-Module -Name $Module -RequiredVersion $Version.Version -Force
          } #End if
       } #End ForEach
   } #End If
 } #End ForEach