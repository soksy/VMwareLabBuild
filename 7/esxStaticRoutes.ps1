Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$IPLIST = '192.168.2.30', '192.168.2.31', '192.168.2.32', '192.168.2.35', '192.168.2.36', '192.168.2.37'

Foreach ($IP in $IPLIST) {
	Connect-VIServer -Server $IP -Protocol https -User root -Password 'XXXXXXXXXXXX'
	New-VMHostRoute -Confirm:$false -Destination 192.168.5.0 -Gateway 192.168.2.254 -PrefixLength 24 -VMHost $IP 
}

