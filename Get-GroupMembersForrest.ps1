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
)

$Members = @()

$domains = (Get-ADForest).domains

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
#         , [Parameter(
#             Mandatory = $true,
#             ValueFromPipeline = $true,
#             ValueFromPipelineByPropertyName = $true,
#             Position = 1
#         )]
#         [string[]]
#         $Domain1
#     )
#     process {
#         foreach ($GroupIdentity in $Identity) {
#             $Group = $null
#             $Group = Get-ADGroup -Identity $GroupIdentity -Properties Member -Server $Domain1
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


Get-ADGroupMember $GroupName -Recursive | Where-Object {$_.objectClass -eq "user"}