#Chapter 12
#1 Get the commands from the PSReadLine module. 
Get-Command -Module PSReadLine

#2 Get the commands using the verb Get from the PSReadLine module. 
#Which is better??
Get-Command -Module PSReadLine -Verb get
Get-Command -Module PSReadLine | Where-Object name -like get*

# Display all files in C:\Windows\Fonts that are larger than 5 MB
#The 2nd line below contains a shortcut way of using where-object
Get-ChildItem -File -Path C:\Windows\Fonts | Where-Object {$_.length -ge 5MB}
Get-ChildItem -File -Path C:\Windows\Fonts | Where length -ge 5MB

#4 Find all modules on the PowerShell Gallery that start with PS and the author starts with Microsoft. 
Find-Module -name PS* |Where-Object {$_.author -like "Micro*"}

#5 Get the files in the current directory where the LastWriteTime is in the last week. 
#(Hint: (Get-Date).AddDays(-7) will give you the date from a week ago.) 
Get-ChildItem -Path ~ -file -Recurse| Where-Object {$_.LastWriteTime -ge (Get-Date).AddDays(-7)}

#6 Display a list of all processes running that start with the letter ‘p’ or ‘w’
#Hint you will need to use the wildcard ‘*’
#The following two lines are equivalent
Get-Process -Name 'P*', 'b*'
Get-Process | Where-Object {($_.name -like "p*") -or ($_.name -like "b*")}

#7. Display the 10 processes with the greatest amount of CPU time.
Get-Process | Sort-Object -Property CPU -Descending |Select-Object -First 10

#8  Display the average CPU time of the 10 processes with the greatest amount of CPU time.  
Get-Process | Sort-Object -Property CPU -Descending |Select-Object -First 10 |Measure-Object -Property CPU -Average
Get-Process | Where-Object {$_.Name -notlike 'W*'} |Sort-Object -Property CPU -Descending |Select-Object -First 10 |Measure-Object -Property CPU -Average

#Rewrite gps| where-object {$_.name -eq 'svchost'}
Get-Process -Name 'svchost'

#Chapter 13
#Windows Remote Management (WinRM) is Mircosoft's implementation of the WS-Management Protocol 
#1. From server22-02, make a one-to-one connection with server22-01. Run hostname
Enter-PSSession -ComputerName Server22-01
Exit-PSSession

#Possible to use SSH (secure shell) as opposed to WinRM for connection negotation and data transport
#SSH needs to be on the local machine and the remote system needs to have PowerShell SSH installed
Enter-PSSession -HostName Server22-01

#2 Using Invoke-Command, retrieve a list of services that aren’t started on server22-01.
#this will return desrialized objects (properties, no methods)
Invoke-command -ComputerName Server22-01 -ScriptBlock {
    Get-Service | where-object status -eq stopped
}

#create a variable that contains a script block
$commands = {
    Get-Service | where-object status -eq stopped
}

Invoke-command -ComputerName Server22-01 -ScriptBlock $commands

#3 Use Invoke-Command to get a list of the top 3 processes for virtual memory (VirtualMemorySize) 
#usage from server22-01 and Win11-Client

$commands = {Get-Process | Sort-Object -Property VirtualMemorySize -Descending | Select-Object -First 3}
Invoke-command -ComputerName Server22-01 -ScriptBlock $commands

#4 Use Invoke-Command to get a list of the top 3 processes
#for virtual memory (VM) usage from server22-01 and Win11-Client
New-Item -Path ~ -Name computers.txt -ItemType File
Add-Content -Path ~\computers.txt -Value Server22-01
Add-Content -Path ~\computers.txt -Value win11-client
Get-Content -Path ~\computers.txt

Invoke-command -ComputerName (Get-Content -Path ~\computers.txt) -ScriptBlock $commands

#5 Using Invoke-Command, query server22-01 and Win11-Client
# to display the property PSVersion from the $PSVersionTable variable
$commands = {$PSVersionTable}
Invoke-command -ComputerName (Get-Content -Path ~\computers.txt) -ScriptBlock $commands
