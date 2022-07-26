<#
.SYNOPSIS
    Gets a list of users in an AD Group
.DESCRIPTION
    Gets a list of users in an AD Group
.EXAMPLE
    PS C:\> Get-UsersFromGroup -GroupName "Group Name in AD" 
    
.INPUTS
    .
.OUTPUTS
    .
.NOTES

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$GroupName
    ,[Parameter(Mandatory=$true)]
    [string]$Domain
)


# Get-ADGroupMember -Identity $GroupName -Recursive -Server $Domain | Get-ADObject -LDAPFilter "objectClass=Contact" -Property DisplayName, DESCRIPTION | Select-Object DisplayName, DESCRIPTION | Sort-Object DisplayName
# Get-ADGroupMember -Identity "$GroupName" -Recursive -Server $Domain | Get-ADUser -Property DisplayName, DESCRIPTION | Select-Object DisplayName, DESCRIPTION | Sort-Object DisplayName
# Get-ADGroupMember -Identity $GroupName -Recursive -Server $Domain | Select-Object DisplayName | Sort-Object DisplayName
# Get-ADGroupMember -Identity "$GroupName"  -Recursive -Server "edmi" | Select-Object name | Sort-Object name 
# Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select Name,ObjectClass,DisplayName

# Function Get-ADGroupMemberFix {
#     [CmdletBinding()]
#     param(
#         [Parameter(
#             Mandatory = $true,
#             ValueFromPipeline = $true,
#             ValueFromPipelineByPropertyName = $true,
#             Position = 0
#         )]
#         [string[]]
#         $Identity
#     )
#     process {
#         foreach ($GroupIdentity in $Identity) {
#             $Group = $null
#             $Group = Get-ADGroup -Identity $GroupIdentity -Properties Member -Server $Domain
#             if (-not $Group) {
#                 continue
#             }
#             Foreach ($Member in $Group.Member) {
#                 Get-ADObject $Member -Server $Domain
#                 # $get1 = Get-ADObject $Member -Server $Domain
#                 # write-host "$get1.name"
#             }
#         }
#     }
# }

# Get-ADGroupMemberFix $GroupName 

Get-ADGroupMember $GroupName -Recursive | Where-Object {$_.objectClass -eq "user"} | select-object name
# | Select-Object Name