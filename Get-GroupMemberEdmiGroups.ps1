param(
    [Parameter(Mandatory=$true)]
    [string]$GroupName
)


Get-ADGroupMember -Identity "$GroupName"  -Server "edmi" | Select-Object name | Sort-Object name 

