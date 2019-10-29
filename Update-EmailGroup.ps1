$groupmembers =  Get-ADGroupMember -Identity  "GROUPDISPLAYNAME" -server edmi.local -Recursive
Add-ADGroupMember -Identity "OTHERGROUPDISPLAYNAME" -server edmi.local -members $groupmembers