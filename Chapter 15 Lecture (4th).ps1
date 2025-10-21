
#WMI Commandlets accessing the WMI repository

#CIM commandlets are newer and provide better remoting capabilities

######################################################################################
#Some CIM cmdlets support -computername, however it's best to use InvokeCommand instead

#Why Use Invoke-Command Instead of -ComputerName?
#✅ 1. Better Performance (Persistent Sessions)
#Invoke-Command allows you to establish a persistent session (New-PSSession), avoiding repeated authentication overhead.
#-ComputerName creates a new connection every time you run Get-CimInstance, which is slower.

#✅ 2. Works in PowerShell 7+
#-ComputerName relies on WSMan/DCOM, which has limited support in PowerShell 7.
#Invoke-Command works well in PowerShell Core and supports cross-platform remoting.

#✅ 3. More Flexibility (Parallel Execution)
#Invoke-Command allows running commands in parallel on multiple computers.
#-ComputerName runs the command one machine at a time, which can be inefficient.
######################################################################################
Get-CimInstance Win32_logicaldisk
Get-CimInstance Win32_logicaldisk -ComputerName "Server22-01"
Invoke-Command -ComputerName Server22-01 -ScriptBlock {Get-CimInstance Win32_logicaldisk} 

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

Get-Service | Where-Object status -eq 'Running'

#-Parallel runs up to 5 script blocks in parallel
Measure-Command {
1..15 | ForEach-Object -parallel {
    Write-Host $_
    sleep -Seconds 1
}
}

#-Execute syncronously
Measure-Command {
    1..15 | ForEach-Object  {
        Write-Host $_
        sleep -Seconds 1
    }
    }
    

#Question #1
#You should see a method called delete
Get-ChildItem | Get-Member -MemberType Method

#Create two folders and then use the method to delete them
New-Item -ItemType Directory ~\DelMePlease1
New-Item -ItemType Directory ~\DelMePlease2

Get-Item -Path ~\DelMePlease*
Get-Item -Path ~\DelMePlease* | foreach-object {$_.Delete()}

#Question #2
#you should see a Kill method
Get-Process | gm | Where-Object MemberType -eq Method
Get-Process | gm -MemberType Property

#Question #3
New-Item -ItemType File "patdeleteme.txt"
New-Item -ItemType File "patReallydeleteme.txt"
New-Item -ItemType Directory "patsdeletemeDirectory"
Get-ChildItem *deleteme* |gm -MemberType method
#this is the preferred way to do it
Get-ChildItem *deleteme* | Remove-Item
#This is an alternate way (using the delete method) 
Get-ChildItem *deleteme* | ForEach-Object -parallel {$_.Delete()}



#Question #4
"Server22-01","Server22-02", "Win11-Client"
"Server22-01","Server22-02", "Win11-Client" | foreach-object {$_.ToUpper()}

#An example of the concepts shown above
Get-ChildItem -Path ~ |ForEach-Object {$_.name.ToUpper()}
