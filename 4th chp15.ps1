
#WMI Commandlets accessing the WMI repository
#CIM Commandlets also access the WMI respository
#CIM commandlets are newer and provide better remoting capabilities

Get-CimInstance Win32_logicaldisk -ComputerName "Server2016-2"
Invoke-Command -ComputerName Server2016-2 -ScriptBlock{Get-CimInstance Win32_logicaldisk
}

#Go to https://wmie.codeplex.com/ and download Easy to show NameSpace, Class, Instance, Property
#checkout Root\Hardware Win32_DiskPartition (should see 2 instances of partition class)

#Windows contains 10,000s of pieces of information.  WMI attempts to organize this info into namespaces, classes & instances

#WMI is external from PowerShell, but PS does interface.  

#WMI cmdlets are legacy and use DCOM and RPC protocols

Get-WmiObject -list -Class "*partition*"  #-list means list all classes
gwmi -ClassName Win32_diskpartition # multiple instances of this class
gwmi win32_diskpartition | Get-Member
gwmi win32_diskpartition | Select-Object systemName, Size

Get-CimInstance -ClassName Win32_DiskPartition
#CIM uses http, firewall friendly, CIM get’s XML returned, where as WMI gets live objects returned

#Display the Cmdlet that use CIM
get-command -module cimcmdlets 

#return all classes with disk
Get-CimClass -class *bios*

#return all instances of win32_bios class
Get-CimInstance -Class win32_bios

#when run locally there is no real difference
get-wmiobject win32_logicaldisk
get-ciminstance Win32_logicaldisk

Get-wmiobject win32_service | ft
Get-ciminstance win32_service | Where-Object state -eq ‘Running’
Get-CimInstance win32_service | Where-Object {($_.state -eq 'Running') -and ($_.status -eq 'OK')}
Get-CimInstance win32_service -Filter "state = 'Running' and status='OK'" -ComputerName Server2016-2

Get-WmiObject win32_logicaldisk | Where-Object drivetype -eq 3
Get-WmiObject win32_logicaldisk -filter “drivetype=3”

#Get-wmiobject supports -credential parameter (CIM does not, you need to use invoke command)
Get-WmiObject win32_logicaldisk -Filter "drivetype=3" -ComputerName Server2016-2 -Credential student

#The following examples are based on the questions from chapter 14

#Question #1
Get-CimClass -ClassName *network*
#Google Win32_NetworkAdapterConfiguration
Get-WmiObject -Class Win32_NetworkAdapterConfiguration
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object IPAddress -ne $null
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object IPAddress, Index
Get-CimInstance -ClassName win32_NetworkAdapterConfiguration  | where-Object IPAddress -ne $null | Select-Object IPAddress, Index 
Get-CimInstance -ClassName win32_NetworkAdapterConfiguration  | where-Object {$_.IPAddress -ne $null} | ForEach-Object {"IP Address: $($_.IPAddress) `t NIC Index:$($_.Index)"}

#Question #2
gwmi -Class win32_bios | Select-Object __Server
gwmi -Class win32_bios | Select-Object @{l='ComputerName';e={$_.__Server}}
gwmi -Class win32_bios | Select-Object SerialNumber

Get-CimInstance Win32_OperatingSystem | select BuildNumber, Caption, @{l='ComputerName';e={$_.CSNAME}}
Get-CimInstance Win32_OperatingSystem | select BuildNumber, Caption, @{l='ComputerName';e={$_.CSNAME}}, @{l='BIOSSerialNumber';e={(Get-CimInstance win32_bios).SerialNumber }}

#Invoke coommand can be used to get info from a remote machine
Invoke-Command -ComputerName server2016-2{
Get-CimInstance Win32_OperatingSystem |
select BuildNumber, caption, CSNAME, @{l='BIOSSerialNumber';e={(Get-CimInstance win32_bios).SerialNumber }}
}

#Question #4
Get-CimInstance Win32_Service| Select-Object Name,State,StartMode,StartName | Select-Object -First 5

#Invoke coommand can be used to get info from a remote machine
Invoke-Command -ComputerName server2016-2{
Get-CimInstance Win32_Service | Select-Object name,state,startmode,startname | Select-Object -First 3
}
