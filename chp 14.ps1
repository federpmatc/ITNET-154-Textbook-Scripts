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