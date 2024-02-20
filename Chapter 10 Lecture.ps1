#PowerShell uses two methods to get the output of one command to another
#ByValue - looks at output object type and checks if input command has parameters that accept this TYPE of object
#ByPropertyname - Looks at output objects PROPERTIES and lines them up input object PARAMETERS

New-Item ~\computers.txt -ItemType file -Force
Add-Content -Path ~\computers.txt "Server2019-1"
Get-Content ~\computers.txt
Set-Location ~
notepad computers.txt

#Disable firewall on remote computer
Set-NetFirewallProfile -Name domain -Enabled False

get-content ~\computers.txt

get-content ~\computers.txt | get-service
#let's figure out what went wrong

get-content ~\computers.txt | gm  #we see that the output object is a string

help get-service -full #-Name parameter is used to specify a service name

get-content ~\computers.txt | Restart-Computer -Confirm  #Computer Name
get-content ~\computers.txt | Test-Connection   #target name

#generate a string[] with computer names
Restart-Computer -confirm -ComputerName ("Server2019-1")
Restart-Computer -computername (get-content ~\computers.txt) -Confirm 
Test-Connection -TargetName (get-content ~\computers.txt)  

#fix #2
#Example - Converting Object Property to a string
get-service -computername ( get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri" | select-object -expand name )

#fix #3
#skip...
#https://powershell.org/forums/topic/piping-computers-to-get-service/
$computers = get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri" | select  @{n='ComputerName';e={$_.name}}
$computers | Get-Service -name *

#Another example, where 'By Value' works
help Restart-Computer -Full #we see that the -computerName is by Value
Clear-Content C:\computers.txt
Add-Content -Path c:\computers.txt "Server2016-2"
Add-Content -Path c:\computers.txt "W10-Client"

#Restart by Value
get-content C:\computers.txt | Restart-Computer -Force
Get-ADComputer -Filter * -SearchBase "OU=Servers,DC=ITNET-112,DC=pri" | Select-Object -ExpandProperty name | Restart-Computer

#ByPropertyName
get-adcomputer -filter * -SearchBase "OU=Workstations, dc=itnet-112, dc=pri"
get-adcomputer -filter * -SearchBase "OU=Workstations, dc=itnet-112, dc=pri" | Restart-Computer
get-adcomputer -filter * -SearchBase "OU=Workstations, dc=itnet-112, dc=pri" |select  *,@{n='ComputerName';e={$_.name}} | Restart-Computer -Force

#Example - ByPropertyName
new-alias -name 'PatFeder' -Value Get-Date
New-Item c:\alias.csv -ItemType file -Force
Add-Content C:\alias.csv "Name, Value", "d, get-childitem", "sel, select-object"

help new-alias -full #note that new-alias accepts -Name ByPropertyName and -Value ByPropertyName.  So we can create
import-csv C:\alias.csv
import-csv C:\alias.csv | gm #We see that our object 
import-csv C:\alias.csv | new-alias
 

#This will work
notepad.exe
Get-process note* | stop-process

#Here's why it works as ByValue.  We see the object types are the same
Get-process note* | gm
help stop-process -full

#Technically one command outputs objects with a -name property and the 2nd command accepts input by property
#however the process names aren't the same as service names
get-process -name spo* | stop-service
get-process -name spo* | gm
help stop-service -full

New-Item c:\newusers.csv -ItemType file -Force
Add-Content C:\newusers.csv "login, dept, city, title", "MATC1, IT, Milwaukee, NoBody", "MATC2, IT, Milwaukee, SomeBody"
notepad c:\newusers.csv


import-csv C:\NewUsers.csv | ft
help new-aduser 
import-csv C:\NewUsers.csv | new-aduser #won't work new-aduser requires samAccountname and Name

import-csv C:\NewUsers.csv | Select-Object *, #the comma indicates that we're continuing the list or propeties
@{name='samAccountName'; expression ={$_.login}},  #Hashtables consist of Key/Value pairs
@{n='Name';e ={$_.login}},
@{n='Department';e ={$_.Dept}}

import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser

import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser

#delete ad users
get-aduser -Filter 'Name -like "MATC*"'| Remove-ADUser

#did some research to set password and enable account -
#http://www.windowsnetworking.com/articles-tutorials/windows-server-2012/creating-active-directory-accounts-using-powershell.html
import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

#messing around... get-aduser -filter specifies query string that retrieves AD objects
get-aduser -filter *
get-aduser -filter * -SearchBase "OU=IT Support, DC=ITNET-112, DC=pri"  #-searchbase specifies AD path
get-aduser -filter 'Name -like "MATC*"' |
Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru 

import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

get-aduser -filter 'Name -like "MATC*"' | Move-ADObject -TargetPath "OU=IT Support, DC=ITNET-112, DC=pri"
#Take what you have seen and delete all the users in IT Support OU
get-aduser -filter * -SearchBase "OU=IT Support, DC=ITNET-112, DC=pri" | Remove-ADUser

#Take what you have seen and disable all the users accounts in IT Support OU
get-aduser -filter * -SearchBase "OU=IT Support, DC=ITNET-112, DC=pri" | Disable-ADAccount
