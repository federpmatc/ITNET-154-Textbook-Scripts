<#
.SYNOPSIS
Sets IP Address, DFG, Subnet and DNS
.DESCRIPTION
Sets IP Address, DFG, Subnet and DNS
.PARAMETER IPAddress
IPv4 IP Address
.PARAMETER DNSAddress
DNS Address
.PARAMETER DFG
Default Gateway Address
.PARAMETER SubnetMask
Subnetmask in bits (i.e. 255.255.255.0 shoudl be entered as 24)
.EXAMPLE
set-ipaddr.ps1 -IPAddress 192.168.222.102 -Subnetmask 24 -DNSAddress 192.168.222.101 -DFG 192.168.222.201 
#>
[CmdletBinding()]
<#The Cmdlet Binding directive adds new features to our script
we can use decorators to help manage our parameters
we can use write-verbose within the script
#>
param (
        [Parameter(Mandatory=$True)][string]$IPAddress,
        [Parameter(Mandatory=$True)][string]$DNSAddress,
        [Parameter(Mandatory=$True)][string]$DFG,
        [byte]$SubnetMask = 24
)

Write-Verbose "IP Address: $IPAddress"
Write-Verbose "Subnet Mask: $subnetmask"
Write-Verbose "DNS Address (Prefix Lengh): $DNSAddress"
Write-Verbose "Default Gateway: $DFG"

$ifIndex = Get-NetAdapter -Physical | Select-Object -ExpandProperty ifIndex

#Remove IP address
$interface = Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily "IPv4"
If ($interface.Dhcp -eq "Disabled") {
 # Remove existing gateway
 If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) { $interface | Remove-NetRoute -Confirm:$false }
 # Enable DHCP
 $interface | Set-NetIPInterface -DHCP Enabled
 # Configure the DNS Servers automatically
 $interface | Set-DnsClientServerAddress -ResetServerAddresses
}
    
#Refer to https://learn.microsoft.com/en-us/powershell/module/nettcpip/new-netipaddress?view=windowsserver2025-ps for more info on this cmdlet
New-netIPAddress -IPAddress $IPAddress -PrefixLength $SubnetMask -DefaultGateway $DFG -InterfaceIndex $ifIndex

Set-DnsClientServerAddress `
        -InterfaceIndex $ifIndex `
        -ServerAddresses $DNSAddress

ipconfig        
Write-host "All done!!!!!"