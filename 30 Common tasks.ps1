#Demo from 30 common tasks you perform using the GUI that you can do faster in Windows PowerShell
#https://channel9.msdn.com/Events/TechEd/NewZealand/2014/DCIM324

Get-NetIPConfiguration
Get-NetIPConfiguration -detailed
Get-NetAdapter
Get-NetAdapterStatistics

#3
#Warning, this will change your IP address
New-NetIPAddress -InterfaceIndex 14 -IPAddress 172.16.2.253 -PrefixLength 16 -DefaultGateway 172.16.1.1 
gcm -Noun *ipaddress*
gcm -noun *dns*

#4
#Warning, this will change your DNS address
Set-DnsClientServerAddress -InterfaceIndex 14 -ServerAddresses "8.8.8.8"

#5
Test-NetConnection google.com

#6
Test-NetConnection google.com -TraceRoute

#7
Test-NetConnection google.com -Port 25
Test-NetConnection smtp.com -Port 25
