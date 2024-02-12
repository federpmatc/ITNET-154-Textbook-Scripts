
#WMI Commandlets accessing the WMI repository

#CIM commandlets are newer and provide better remoting capabilities

Get-CimInstance Win32_logicaldisk -ComputerName "Server2019-1"
Invoke-Command -ComputerName Server2019-1 -ScriptBlock {Get-CimInstance Win32_logicaldisk} 

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

Get-ciminstance win32_service | Where-Object state -ne ‘Running’
Get-CimInstance win32_service | Where-Object {($_.state -eq 'Running') -and ($_.status -eq 'OK')}
Get-CimInstance win32_service -Filter "state = 'Running' and status='OK'" -ComputerName Server2019-1

Get-Service | Where-Object state -eq 'Running'

#-Parallel runs up to 5 script blocks in parallel
Measure-Command {
1..15 | ForEach-Object -parallel {
    Write-Host $_
    sleep -Seconds 1
}
}



#Question #1
Get-ChildItem | Get-Member

#Question #2
Get-Process | gm | Where-Object MemberType -eq Method
Get-Process | gm -MemberType Property

#Question #3
New-Item -ItemType File "patdeleteme.txt"
New-Item -ItemType File "patReallydeleteme.txt"
New-Item -ItemType Directory "patsdeletemeDirectory"
Get-ChildItem *deleteme* |gm -MemberType method
Get-ChildItem *deleteme* | Remove-Item 
Get-ChildItem *deleteme* | ForEach-Object -parallel {$_.Delete()}
Get-ChildItem *deleteme* | Remove-Item


#Question #4
get-content computers.xt | foreach-object {$_.ToUpper()}
Get-ChildItem *deleteme* |ForEach-Object {$_.name.ToUpper()}
