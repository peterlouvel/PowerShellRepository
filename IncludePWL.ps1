<#

    INPUTS
        $UserName       - "bob hope"
        $UsersDomain    - "au" or "nz"  if empty will use your current domain 
    OUTPUTS
        $UserName       - "Bob Hope"
        $UserAccount    - "Bob.Hope"
        $End            - "@edmi.com.au"            or  "@edmi.co.nz"
        $UserEmail      - "Bob.Hope@edmi.com.au"    or "Bob.Hope@edmi.co.nz"
        $FQD            - "au.edmi.local"           or  "nz.edmi.local"
        $Location       - "Australia"               or  "New Zealand"
        $DomainController - "AuBneDC11.au.edmi.local" or "NzBneDC5.nz.edmi.local"
        $Cred           - your admin credentials (if not already setup)
        $AdminAccount   - your admin account name (scottw_  peter.louvel_  Blair.Townley_)
        $stYourDomain   - your domain  "au" or "nz"

    NOTES
        Used in front of PS scripts just after param()
        
        param(
            [Parameter(Mandatory=$true)]
            [string]$UserName
            ,[Parameter(Mandatory=$false)]
            [string]$UsersDomain
        )   
        .".\IncludePWL.ps1"
#>

[String] ${stYourDomain},[String]  ${stYourAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
$AdminAccount = $stYourAccount + "_"

if ($UsersDomain -eq "z"){
    $UsersDomain=$stYourDomain
}

if ($UsersDomain -eq "au"){
    $End = "@edmi.com.au"
    $DomainController = "AuBneDC11.au.edmi.local"
    $FQD = "au.edmi.local"
    $AdminAccount1 = "au\"+$AdminAccount
    $Location = "Australia"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1} 
} elseif ($UsersDomain -eq "nz"){
    $End = "@edmi.co.nz"
    # $DomainController = "NZwlgDC3.nz.edmi.local"
    $DomainController = "NzBneDC5.nz.edmi.local"
    $FQD = "nz.edmi.local"
    $AdminAccount1 = "nz\"+$AdminAccount
    $Location = "New Zealand"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "uk"){
    $End = "@edmi-meters.com"
    # $DomainController = "UkRdgDC1.uk.edmi.local"
    $DomainController = "UkBneDC2.uk.edmi.local"
    $FQD = "uk.edmi.local"
    $AdminAccount1 = "uk\"+$AdminAccount
    $Location = "United Kingdom"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "sg"){
    $End = "@edmi-meters.com"
    $DomainController = "SgBneDC1.sg.edmi.local"
    $FQD = "sg.edmi.local"
    $AdminAccount1 = "sg\"+$AdminAccount
    $Location = "Singapore"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} elseif ($UsersDomain -eq "edmi"){
    $End = "@edmi-meters.com"
    $DomainController = "edmiBneDC11.edmi.local"
    $FQD = "edmi.local"
    $AdminAccount1 = "edmi\"+$AdminAccount
    $Location = "Brisbane"
    if ($null -eq $Cred){
        $Cred = Get-Credential $AdminAccount1}
} else {
    Write-Host
    Write-Host "Domain should be edmi, AU, NZ, UK, SG" -ForegroundColor Red 
    $ErrorActionPreference = "SilentlyContinue"
}

if ($null -eq $UPNAccount){
    $UPNAccount = (get-aduser ($Env:USERNAME)).userprincipalname
}

if ($null -eq $EDMICREDS){
    $EDMICREDS = Get-Credential "edmi\$AdminAccount"
} 

# $UserLowerCase  = $UserName.ToLower()
$UserName       = (Get-Culture).TextInfo.ToTitleCase($UserName.ToLower()) 
$UserAccount    = $UserName -replace ' ','.'
$UserEmail      = $UserAccount.ToLower() + $End
