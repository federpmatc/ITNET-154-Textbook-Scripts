#PowerShell uses two methods to get the output of one command to another
#ByValue - looks at output object type and checks if input command has parameters that accept this TYPE of object
#ByPropertyname - Looks at output objects PROPERTIES and lines them up input object PARAMETERS

New-Item c:\computers.txt -ItemType file
Add-Content -Path c:\computers.txt "Server2016-1", "Server2016-2"
notepad C:\computers.txt

#Disable firewall on Server2016-2
#Set-NetFirewallProfile -Name domain -Enabled False

get-content C:\computers.txt

get-content C:\computers.txt | get-service
#let's figure out what went wrong

get-content C:\computers.txt | gm  #we see that the output object is a string

help get-service -full #-Name parameter is used to specify a service name

#fix #1 - generate a string[] with computer names
Get-Service -ComputerName ("Server2016-1","Server2016-2") 
get-service -computername (get-content C:\computers.txt) | select status, name, displayname, MachineName | Sort-Object machinename, displayname | ft #-AutoSize

#fix #2
#Example - Converting Object Property to a string
get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri"
get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri" | select-object name | gm #this is not a string, required by get-service
get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri" | select-object -expand name | gm #this is a string, required by get-service
get-service -computername ( get-adcomputer -filter * -SearchBase "ou=domain controllers, dc=itnet-112, dc=pri" | select-object -expand name )

#Another example, where 'By Value' works
help Restart-Computer -Full #we see that the -computerName is by Value
Clear-Content C:\computers.txt
Add-Content -Path c:\computers.txt "Server2016-2"
get-content C:\computers.txt | Restart-Computer -Force

#Example - ByPropertyName
New-Item c:\alias.csv -ItemType file
Add-Content C:\alias.csv "Name, Value", "d, get-childitem", "sel, select-object"

help new-alias -full #note that new-alias accepts -Name ByPropertyName and -Value ByPropertyName.  So we can create
import-csv C:\alias.csv
import-csv C:\alias.csv | gm #We see that our object 
import-csv C:\alias.csv | new-alias
gal

#This will work
Get-process note* | stop-process

#Here's why it works as ByValue.  We see the object types are the same
Get-process note* | gm
help stop-process -full

#Technically one command outputs objects with a -name property and the 2nd command accepts input by property
#however the process names aren't the same as service names
get-process -name spo* | stop-service
get-process -name spo* | gm
help stop-service -full

#get-hotfix does not accept input by Value
Help Get-HotFix -Full
get-content C:\computers.txt | get-hotfix   #There are no parameters that accept and array of strings (by value)

#however we can use import-csv to create objects with any property name that we want
Notepad C:\computers.csv
#Comp_Name, Location
#Server2016-1, M410
#Server2016-2, M406

#Modify computers.csv so the following works
import-csv C:\computers.csv | gm #get-hotfix 

#creating custom properties
#notepad c:\newusers.csv
#login, dept, city, title
#FederP, IT, Milwaukee, NoBody
#DavisL, IT, Milwaukee, SomeBody

import-csv C:\NewUsers.csv | ft -AutoSize
help new-aduser 
import-csv C:\NewUsers.csv | new-aduser #won't work new-aduser requires samAccountname and Name

import-csv C:\NewUsers.csv | Select-Object *, #the comma indicates that we're continuing the list or propeties
@{name='samAccountName'; expression ={$_.login}},  #Hashtables consist of Key/Value pairs
@{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}}

import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser 

#delete ad users
import-csv C:\NewUsers.csv |get-aduser -Identity {$_.login } | Remove-ADUser



#did some research to set password and enable account -
#http://www.windowsnetworking.com/articles-tutorials/windows-server-2012/creating-active-directory-accounts-using-powershell.html
import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

#messing around... get-aduser -filter specifies query string that retrieves AD objects
get-aduser -filter *
get-aduser -filter * -SearchBase "OU=IT Support, DC=ITNET-112, DC=pri"  #-searchbase specifies AD path
get-aduser -filter * -SearchBase "OU=IT Support, DC=ITNET-112, DC=pri" |
Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru 

#Take what you have seen and delete all the users in IT Support OU

#Take what you have seen and disable all the users accouns in IT Support OU

#Restart all of the computers in the Servers OU
#region
Get-ADComputer -Filter * -SearchBase "OU=Servers,DC=ITNET-112,DC=pri" | Select-Object -ExpandProperty name | Restart-Computer
#endregion
