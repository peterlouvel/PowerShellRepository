<# .Synopsis install vpn connection, to remove: "Remove-VpnConnection -Name %VPNNAME%" #>

Param(
    [Parameter(Mandatory=$true)]
    [String]$hostname
)

$vpn_name = "edmicorp-nz"
$vpn_suffix = ".edmi.co.nz"
$route_list = "\\nz.edmi.local\NETLOGON\routes.txt"
[xml]$eapcfg = @"
<EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><EapMethod><Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type><VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId><VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType><AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId></EapMethod><Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>25</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV1"><ServerValidation><DisableUserPromptForServerValidation>false</DisableUserPromptForServerValidation><ServerNames></ServerNames><TrustedRootCA>53 b1 b1 67 42 a2 24 40 ed a7 99 cf be 8d 8a d2 23 02 39 b4 </TrustedRootCA><TrustedRootCA>a4 5c de 26 e9 56 84 8c 74 1d 5c 1e 4e a3 84 34 f2 1f 27 23 </TrustedRootCA></ServerValidation><FastReconnect>true</FastReconnect><InnerEapOptional>false</InnerEapOptional><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>26</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsChapV2ConnectionPropertiesV1"><UseWinLogonCredentials>true</UseWinLogonCredentials></EapType></Eap><EnableQuarantineChecks>false</EnableQuarantineChecks><RequireCryptoBinding>false</RequireCryptoBinding><PeapExtensions><PerformServerValidation xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</PerformServerValidation><AcceptServerName xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">false</AcceptServerName></PeapExtensions></EapType></Eap></Config></EapHostConfig>
"@


try {
		$error.clear()
		$split_vpn_name = $vpn_name + "-split"
		$state = Get-VpnConnection -Name $split_vpn_name -ErrorAction SilentlyContinue
		if (!$error) {
			$routes = get-content $route_list
			foreach ( $route in $routes ) 
				{Add-VpnConnectionRoute -ConnectionName $split_vpn_name -DestinationPrefix $route}
			exit
		}
		else {
			$server_address = $hostname + $vpn_suffix
			Add-VpnConnection -name $vpn_name `
			-ServerAddress $server_address `
			-TunnelType Ikev2 `
			-EncryptionLevel Maximum `
			-AuthenticationMethod Eap `
			-EapConfigXmlStream $eapcfg
			$vpn_name = $vpn_name + "-split"
			Add-VpnConnection -name $vpn_name `
			-ServerAddress $server_address `
			-TunnelType Ikev2 `
			-EncryptionLevel Maximum `
			-AuthenticationMethod Eap `
			-EapConfigXmlStream $eapcfg `
			-SplitTunneling
			try {
				$routes = get-content $route_list
				foreach ( $route in $routes ) 
				{Add-VpnConnectionRoute -ConnectionName $vpn_name -DestinationPrefix $route}
			}
			catch {
				$ErrorMessage = $_.Exception.Message
				$FailedItem = $_.Exception.ItemName
			}
		}
}
catch {
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
}

