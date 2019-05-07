<#
        https://mikefrobbins.com/2014/01/30/add-an-active-directory-user-to-the-same-groups-as-another-user-with-powershell/

 #>
function Copy-User {
<#
.SYNOPSIS
    Create user account from an exisiting user
.DESCRIPTION 
    Create user account from an exisiting user
.EXAMPLE
    PS C:\> Copy-User -Name Bob.Person -From John.OtherPerson
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes


#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [int]$num1,
        [Parameter(Mandatory=$True)]
        [int]$num2
    )
    
    $n1 = $num1
    $n2 = $num2

    $n1 * $n2

}


function Get-UsersGroups {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
    }
}
