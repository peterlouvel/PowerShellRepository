# Circular.ps1
# List all AD groups that contain one or more circular nested groups
# outputs the parent group's DN and a list of the nested groups.

# Limitations
# The script works by scanning through every group, so any circular relationships
# will be listed twice, once for the parent group and once for the child.

# ADSI has a limit of 1500 items for a multi-valued attribute so 
# groups containing more than 1500 members may return the error:
#  "Get-ADGroupMember : The size limit for this request was exceeded.."

# If a circular relationship exists between a large (>1500) group and small one,
# the script may fail enumerating the large group, but still detect the circular
# relationship against the small one.

# This script only checks direct members A>B>A and inherited circular memberships A>B>C>A 

cls
# Import-Module Activedirectory
$outFile = 'c:\temp\CircularCheck.txt'
if (!(Test-Path "c:\temp")){New-Item -Path "c:\temp" -ItemType Directory | Out-Null}
if (Test-Path $outFile) {Remove-Item $outFile}
New-Item -Path $outFile -ItemType File | Out-Null
Add-Content -Path $outFile -Value (Get-Date) 
write-host "Circular.ps1  Search for nested groups - getting Groups"
# Retrieve all top/parent level AD groups.
$Parents = get-adgroup -ResultPageSize 1000 -filter 'ObjectClass -eq "group"' -Server "edmi.local"
# Loop through each parent group
ForEach ($Parent in $Parents) { 
   [int]$Len = 0
   # Create an array of the group members, limited to sub-groups (not users)
   $Children = @(Get-ADGroupMember "$Parent" -Server "edmi.local" | where {$_.objectClass -eq "group"} )
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
            Add-Content -Path $outFile -Value "$nested"
         }
         write-host "---check further nesting" -ForegroundColor Green -NoNewline 
         ForEach ($Parent1 in $Child) {
            $Server = "edmi.local"
            if ($Parent1 -like "*DC=au*"){$Server = "au.edmi.local"}
            if ($Parent1 -like "*DC=nz*"){$Server = "nz.edmi.local"}
            if ($Parent1 -like "*DC=uk*"){$Server = "uk.edmi.local"}
            if ($Parent1 -like "*DC=sg*"){$Server = "sg.edmi.local"}
            [int]$Len1 = 0
            # Create an array of the group members, limited to sub-groups (not users)       
            $Children1 = @(Get-ADGroupMember "$Parent1" -Server "$Server" | where {$_.objectClass -eq "group"}) 
            $Len1 = @($Children1).Count
            if ($Len1 -eq 1) {write-host " contains 1 group " -ForegroundColor Cyan -NoNewline}
            elseif ($Len1 -gt 0) {write-host " contains $Len1 groups " -ForegroundColor Cyan -NoNewline}
            if ($Len1 -gt 0) {
               write-host "--check nesting" -ForegroundColor DarkYellow
               ForEach ($Child1 in $Children1) {
                  # Now find any member of $Child1 is also a member of the $Parent 
                  $nested1 = @(Get-ADGroupMember $Child1 | where {$_.objectClass -eq "group" -and "$_" -eq "$Parent"} )
                  $NestCount1 = @($nested1).Count
                  write-host "- $Child1 " -ForegroundColor DarkYellow
                  if ($NestCount1 -gt 0) {
                     write-host "  Found a circular nested group:" -ForegroundColor DarkRed -NoNewline 
                     write-host " $nested1" -ForegroundColor Cyan
                     write-host " is both a parent and a member of" -ForegroundColor DarkRed
                     Add-Content -Path $outFile -Value "$nested1"
                  }
               }
            #write-host "--done" -ForegroundColor Green
            }else{write-host ""}
         }
      }
   #write-host "--done" -ForegroundColor Green
   }
}

