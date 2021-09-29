# $ErrorActionPreference = 'SilentlyContinue'
# Circular.ps1

# ADSI has a limit of 1500 items for a multi-valued attribute so 
# groups containing more than 1500 members may return the error:
#  "Get-ADGroupMember : The size limit for this request was exceeded.."

# If a circular relationship exists between a large (>1500) group and small one,
# the script may fail enumerating the large group, but still detect the circular
# relationship against the small one.

# This script only checks direct members A>B>A and inherited circular memberships A>B>C>A 

param(
    [Parameter(Mandatory=$true)]
    [string]$Group
    ,[Parameter(Mandatory=$false)]
    [string]$Server = "edmi.local"
)

cls
# Import-Module Activedirectory

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

write-host "Circular.ps1  Search for nested groups - getting Groups"
# Retrieve all top/parent level AD groups.
$Parents = get-adgroup -ResultPageSize 1000 -filter 'ObjectClass -eq "group"' -Server "$Server" | Where-Object Name -eq "$Group"

# Loop through each parent group
ForEach ($Parent in $Parents) {
   [int]$Len = 0
   # Create an array of the group members, limited to sub-groups (not users)
   $Children = @(Get-ADGroupMember "$Parent" -Server "$Server" | where {$_.objectClass -eq "group"} )
   $Len = @($Children).Count

   if ($Len -eq 1) {
      Write-host "$Parent" -ForegroundColor White -NoNewline
      write-host " contains 1 group " -ForegroundColor Cyan -NoNewline
   }
   elseif ($Len -gt 0) {
      Write-host "$Parent" -ForegroundColor White -NoNewline
      write-host " contains $Len groups " -ForegroundColor Cyan -NoNewline
   }
   
   if ($Len -gt 0) {
      write-host "--check nesting" -ForegroundColor Green
      ForEach ($Child in $Children) {
         # Now find any member of $Child which is also the childs $Parent
         $nested = @(Get-ADGroupMember $Child | where {$_.objectClass -eq "group" -and "$_" -eq "$Parent"} )
         $NestCount = @($nested).Count
         write-host "- $Child " -ForegroundColor Cyan -NoNewline
         if ($NestCount -gt 0) {
            write-host ""
            write-host "   Fopund a circular nested group:" -ForegroundColor Red -NoNewline 
            write-host " $nested" -ForegroundColor Cyan -NoNewline 
            write-host " is both a parent and a member of " -ForegroundColor Red -NoNewline 
         }


         write-host "---check further nesting" -ForegroundColor Green 
         ForEach ($Parent1 in $Child) {
            # write-host "$Parent1"
            $Server = "edmi.local"
            if ($Parent1 -like "*DC=au*"){$Server = "au.edmi.local"}
            if ($Parent1 -like "*DC=nz*"){$Server = "nz.edmi.local"}
            if ($Parent1 -like "*DC=uk*"){$Server = "uk.edmi.local"}
            if ($Parent1 -like "*DC=sg*"){$Server = "sg.edmi.local"}

            [int]$Len1 = 0
            # write-host "$Server"
            # Create an array of the group members, limited to sub-groups (not users)       
            $Children1 = @(Get-ADGroupMember "$Parent1" -Server "$Server" | where {$_.objectClass -eq "group"}) 
            $Len1 = @($Children1).Count

            if ($Len1 -eq 1) {write-host " contains 1 group " -ForegroundColor Cyan -NoNewline}
            elseif ($Len1 -gt 0) {write-host " contains $Len1 groups " -ForegroundColor Cyan -NoNewline}
            
            if ($Len1 -gt 0) {
               write-host "--check nesting" -ForegroundColor DarkYellow
               ForEach ($Child1 in $Children1) {
                  # Now find any member of $Child1 which is also the $Parent
                  $nested1 = @(Get-ADGroupMember $Child1 | where {$_.objectClass -eq "group" -and "$_" -eq "$Parent"} )
                  $NestCount1 = @($nested1).Count
                  write-host "- $Child1 " -ForegroundColor DarkYellow
                  if ($NestCount1 -gt 0) {
                     write-host "  Found a circular nested group:" -ForegroundColor DarkRed -NoNewline 
                     write-host " $nested" -ForegroundColor Cyan
                     write-host " is both a parent and a member of" -ForegroundColor DarkRed
                  }
               }
            #write-host "--done" -ForegroundColor Green
            }else{write-host ""}
         }
      }
   #write-host "--done" -ForegroundColor Green
   }
}

