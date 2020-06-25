#Go to https://wmie.codeplex.com/ and download Easy to show NameSpace, Class, Instance, Property
#checkout Root\Hardware Win32_DiskPartition (should see 2 instances of partition class)

#Windows contains 10,000s of pieces of information.  WMI attempts to organize this info into namespaces, classes & instances

#WMI is external from PowerShell, but PS does interface.  

#We have WMI-CMDLETS (legacy) and CIM cmdlets (new)

#WMI cmdlets are legacy and use DCOM and RPC to i/f with Common Information Model (CIM)
#Some aspects of WMI cmdlets are disabled in Server2012R2
gwmi -list -Class "*partition*"  #-list means list all classes
gwmi -class win32_diskpartition # multiple instances of this class
gwmi -class win32_diskpartition | gm
gwmi -class win32_diskpartition | ft systemName, Size



#CIM uses http, firewall friendly, CIM get’s XML returned, where as WMI gets live objects returned

#Display the Cmdlet that use CIM
get-command -module cimcmdlets 

#return all classes with disk
get-cimclass -class *disk*

#return all instances of win32_bios class
Get-CimInstance -Class win32_bios

#when run locally there is no real difference
get-wmiobject win32_logicaldisk
get-ciminstance Win32_logicaldisk

get-wmiobject win32_service
get-ciminstance win32_service | where state -eq ‘Running’
Get-CimInstance win32_service | Where {($_.state -eq 'Running') -and ($_.status -eq 'OK')}
get-ciminstance win32_service -Filter "state='Running'"

Get-WmiObject win32_logicaldisk | where drivetype -eq 3
Get-WmiObject win32_logicaldisk -filter “drivetype=3”

#Get-wmiobject supports -credential parameter (CIM does not, you need to use invoke command)
Get-WmiObject win32_logicaldisk -Filter "drivetype=3" -ComputerName m410-23 -Credential student

#The following examples are based on the questions from chapter 14

#Question #1
#https://mcpmag.com/articles/2018/06/07/powershell-with-network-adapter.aspx
(Get-WmiObject -Class Win32_NetworkAdapterConfiguration).Where{$_.IPAddress}

#So this looks more like what we have done in the book so far.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress -ne $null}
Get-CimInstance -ClassName win32_NetworkAdapterConfiguration  | foreach {"IP Address: $($_.IPAddress) `t`t`t`t`t NIC Index:$($_.Index)"}
Get-CimInstance -ClassName win32_NetworkAdapterConfiguration  | where-Object {$_.IPAddress -ne $null} | foreach {"IP Address: $($_.IPAddress) `t`t`t`t`t NIC Index:$($_.Index)"}
Get-CimClass win32_NetworkAdapterConfiguration | fl

#Question #2
gwmi -Class win32_bios | FT @{l='ComputerName';e={$_.__Server}}
gwmi -Class win32_bios | FT manufacturer
(gwmi -Class win32_operatingsystem).BuildNumber

Get-CimInstance Win32_OperatingSystem | select BuildNumber, caption, @{l='ComputerName';e={$_.CSNAME}}
Get-CimInstance Win32_OperatingSystem | select BuildNumber, caption, CSNAME, @{l='BIOSSerialNumber';e={(Get-CimInstance win32_bios).SerialNumber }}|ft -AutoSize

#Invoke coommand can be used to get info from a remote machine
Invoke-Command -ComputerName server2016-2{
Get-CimInstance Win32_OperatingSystem | select BuildNumber, caption, CSNAME, @{l='BIOSSerialNumber';e={(Get-CimInstance win32_bios).SerialNumber }}|ft -AutoSize
}

#Question #4
Get-CimInstance Win32_Service | Select-Object Name,State,StartMode,StartName | select -First 15

#Invoke coommand can be used to get info from a remote machine
Invoke-Command -ComputerName server2016-2{
Get-CimInstance Win32_Service | Select-Object name,state,startmode,startname
}
