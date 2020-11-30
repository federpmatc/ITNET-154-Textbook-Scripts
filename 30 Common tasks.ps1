#Demo from 30 common tasks you perform using the GUI that you can do faster in Windows PowerShell
#https://channel9.msdn.com/Events/TechEd/NewZealand/2014/DCIM324

#1
Get-NetIPConfiguration
Get-NetIPConfiguration -detailed

#2
Get-NetAdapter
Get-NetAdapterStatistics  #shows NICs w/ traffic

#3
#Warning, this will change your IP address
New-NetIPAddress -InterfaceIndex 14 -IPAddress 172.16.2.253 -PrefixLength 16 -DefaultGateway 172.16.1.1 
gcm -Noun *ipaddress*
gcm -noun *dns*

#4
#Warning, this will change your DNS address
Set-DnsClientServerAddress -InterfaceIndex 14 -ServerAddresses "8.8.8.8"

#5
Test-NetConnection  #Tests against a MS server

#6
Test-NetConnection google.com -TraceRoute

#7
Test-NetConnection smtp.com -Port 25

#8 
Get-Service

#9 
Get-Service | Out-gridview

#10
Stop-Service
Start-Service
Set-Service

#11
Rename-Computer PCName

#12
Restart-Computer

#13
Shutdown-Computer

#14
#Domain Join
#15 Add Roles & Features

#16 Fix Computer trust relationship
Test-ComputerSecureChannel -Credential domain\admin -Repair

#17
Set-NetFirewallProfile -Profile domain,public,private -Enabled false
Get-NetFirewallProfile

#18 Add Firewall Rules

#19 Create VMs

#20 Assign VM Network

#21 

#22 Password Reset
$newpwd = ConvertTo-SecureString -String "Password01" -AsPlainText -Force
Set-adaccountPassword Optimus -NewPassword $newpwd -Reset
Set-adaccountPassword Optimus -NewPassword $newpwd -Reset -passthru | set-aduser -ChangePasswordAtLogon $True

#23 Locate FSMO Roles
#24 Seize FSMO Roles
#25 Enable Remote Desktop, 
Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0
Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 1

#26 
Get-HotFix

#Date abd Timezone
Set-Date
TZUTIL /s "New Zealand Standard Time"
(Get-WmiObject win32_timezone).caption

#28-30
Search-ADAccount -PasswordNevewrExpires | Out-GridView
#Can modify, if haven't logged then disable
#Search for locked accounts
#Search for disabled accounts
