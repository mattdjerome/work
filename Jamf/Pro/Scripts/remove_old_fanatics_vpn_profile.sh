#!/bin/bash

#!/bin/bash

oldProfile="/opt/cisco/secureclient/vpn/profile/fanaticsVPN.xml"
if [[ -f "$oldProfile" ]]; then
	cd $oldProfile
	echo "$oldProfile exists, deleting profile"
	rm $oldProfile
fi


FilePath="/opt/cisco/secureclient/vpn/profile/Fan_VPN_Profiles.xml"

# Write a valid plist
cat << EOF > "$FilePath"
<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.xmlsoap.org/encoding/ AnyConnectProfile.xsd">
	<ClientInitialization>
		<UseStartBeforeLogon UserControllable="true">true</UseStartBeforeLogon>
		<AutoConnectOnStart UserControllable="true">false</AutoConnectOnStart>
		<MinimizeOnConnect UserControllable="true">true</MinimizeOnConnect>
		<LocalLanAccess UserControllable="true">false</LocalLanAccess>
		<DisableCaptivePortalDetection UserControllable="true">false</DisableCaptivePortalDetection>
		<AutoUpdate UserControllable="false">true</AutoUpdate>
		<ClearSmartcardPin UserControllable="false">true</ClearSmartcardPin>
		<ShowPreConnectMessage>false</ShowPreConnectMessage>
		<CertificateStore>All</CertificateStore>
		<CertificateStoreMac>All</CertificateStoreMac>
		<CertificateStoreLinux>All</CertificateStoreLinux>
		<CertificateStoreOverride>true</CertificateStoreOverride>
		<SuspendOnConnectedStandby>false</SuspendOnConnectedStandby>
		<WindowsLogonEnforcement>SingleLocalLogon</WindowsLogonEnforcement>
		<LinuxLogonEnforcement>SingleLocalLogon</LinuxLogonEnforcement>
		<WindowsVPNEstablishment>LocalUsersOnly</WindowsVPNEstablishment>
		<LinuxVPNEstablishment>LocalUsersOnly</LinuxVPNEstablishment>
		<IPProtocolSupport>IPv4,IPv6</IPProtocolSupport>
		<AutoReconnect UserControllable="false">true
			<AutoReconnectBehavior UserControllable="false">ReconnectAfterResume</AutoReconnectBehavior>
		</AutoReconnect>
		<RSASecurIDIntegration UserControllable="false">Automatic</RSASecurIDIntegration>
		<AllowLocalProxyConnections>true</AllowLocalProxyConnections>
		<AuthenticationTimeout>30</AuthenticationTimeout>
		<CaptivePortalRemediationBrowserFailover>false</CaptivePortalRemediationBrowserFailover>
		<AllowManualHostInput>true</AllowManualHostInput>
		<AutomaticCertSelection UserControllable="false">true</AutomaticCertSelection>
		<ProxySettings>Native</ProxySettings>
		<AutomaticVPNPolicy>false</AutomaticVPNPolicy>
		<PPPExclusion UserControllable="false">Disable
			<PPPExclusionServerIP UserControllable="false"></PPPExclusionServerIP>
		</PPPExclusion>
		<EnableScripting UserControllable="false">false</EnableScripting>
		<EnableAutomaticServerSelection UserControllable="false">false</EnableAutomaticServerSelection>
		<RetainVpnOnLogoff>false</RetainVpnOnLogoff>
	</ClientInitialization>
	<ServerList>
		<HostEntry>
			<HostName>Fanatics VPN</HostName>
			<HostAddress>vpn.fanatics.com</HostAddress>
			<UserGroup></UserGroup>
			<AutomaticSCEPHost></AutomaticSCEPHost>
		</HostEntry>
		<HostEntry>
			<HostName>Fanatics UK VPN</HostName>
			<HostAddress>acs.fanatics.co.uk</HostAddress>
			<UserGroup></UserGroup>
			<AutomaticSCEPHost></AutomaticSCEPHost>
		</HostEntry>
		<HostEntry>
			<HostName>SecureAthlete VPN</HostName>
			<HostAddress>secureathlete.fanatics.com</HostAddress>
			<UserGroup></UserGroup>
			<AutomaticSCEPHost></AutomaticSCEPHost>
		</HostEntry>
	</ServerList>
</AnyConnectProfile>
EOF
if [[ -e $FilePath ]]; then
	echo "Fan_VPN_Profiles.xml created"
else
	echo "Unknown error"
	exit 1
fi

exit 0
