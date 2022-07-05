
#WMI Commandlets accessing the WMI repository

#CIM Commandlets also access the WMI respository
#CIM commandlets are newer and provide better remoting capabilities

Get-CimInstance Win32_logicaldisk -ComputerName "Server2019-2"
Invoke-Command -ComputerName Server2019-1 -ScriptBlock{Get-CimInstance Win32_logicaldisk} 

#Install WMI Explorer download Easy to show NameSpace, Class, Instance, Property
#Checkout Win32 LogicalDisk
#Windows contains 10,000s of pieces of information.  WMI attempts to organize this info into namespaces, classes & instances

#WMI is external from PowerShell, but PS does interface.  

#WMI cmdlets are legacy and use DCOM and RPC protocols

Get-CimInstance -ClassName Win32_DiskPartition 

#Display the Cmdlet that use CIM
get-command -module cimcmdlets 

#return all classes with disk
Get-CimClass -class *bios*

#return all instances of win32_bios class
Get-CimInstance -Class win32_bios

#when run locally there is no real difference
get-ciminstance Win32_logicaldisk

Get-ciminstance win32_service | Where-Object state -eq ‘Running’
Get-CimInstance win32_service | Where-Object {($_.state -eq 'Running') -and ($_.status -eq 'OK')}
Get-CimInstance win32_service -Filter "state = 'Running' and status='OK'" -ComputerName Server2019-1

#-Parallel runs up to 5 script blocks in parallel
Measure-Command {
1..5 | ForEach-Object -Parallel {
    Write-Host $_
    sleep -Seconds 1
}
}



#Question #1
Get-CimClass -Cl

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
