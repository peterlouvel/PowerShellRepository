param(
    [Parameter(Mandatory=$true)]
    [string]$GroupName
)


Get-ADGroupMember -Identity "$GroupName" -Recursive -Server "edmi" | Select-Object name | Sort-Object name 

