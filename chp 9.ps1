#PowerShell uses two methods to get the output of one command to another
#ByValue - looks at output object type and checks if input command has parameters that accept this TYPE of object
#ByPropertyname - Looks at output objects PROPERTIES and lines them up input object PARAMETERS

gci env:\
Set-Location $env:USERPROFILE

New-Item -Path $env:USERPROFILE -Name computers.txt -ItemType file
Add-Content -Path computers.txt "Server2019-1", "Server2019-2"
notepad computers.txt

#Server2019-2
Get-NetFirewallProfile | Out-GridView
Get-NetFirewallProfile | select name, enabled
Set-NetFirewallProfile -All -Enabled False

#Disable firewall on Server2019-2
#Set-NetFirewallProfile -Name domain -Enabled False

get-content computers.txt

get-content computers.txt | get-service
#let's figure out what went wrong

get-content computers.txt | gm  #we see that the output object is a string

help get-service -full #-Name parameter accepts pipeline input & is used to specify a service name

#fix #1 - generate a string[] with computer names
Get-Service -ComputerName ("Server2019-2","Server2019-1") 
Get-Service -computername (get-content computers.txt) | select status, name, displayname, MachineName | Sort-Object machinename, displayname 

#fix #2
#Example - Converting Object Property to a string
get-service -computername ( get-adcomputer -filter 'name -like "serv*"' | select-object -expand name )

#fix #3
#skip...
#https://powershell.org/forums/topic/piping-computers-to-get-service/
#The following is an example of by property name
$computers = get-adcomputer -filter 'name -like "s*"' | select  @{n='ComputerName';e={$_.name}}
$computers | Get-Service -name *

#get-hotfix accepts input by property name
Help Get-HotFix -Full
$computers = get-adcomputer -filter 'name -like "ser*"' | select  @{n='ComputerName';e={$_.name}}
$computers | Get-HotFix

#Example, 'By Value'
help Restart-Computer -Full #we see that the -computerName is by Value (string objects)
Clear-Content computers.txt
Add-Content -Path computers.txt "Server2019-2"
Add-Content -Path computers.txt "W10-Client"
get-content computers.txt | Restart-Computer -force

Get-ADComputer -Filter 'name -like "W*"' | Select-Object -ExpandProperty name | Restart-Computer

#By property Name
get-adcomputer -filter * -SearchBase "CN=Computers, dc=itnet, dc=pri"
get-adcomputer -filter * -SearchBase "CN=Computers, dc=itnet, dc=pri" | Restart-Computer   #our objects have a name but not 'computername'
get-adcomputer -filter * -SearchBase "CN=Computers, dc=itnet, dc=pri" | select *, @{n='ComputerName';e={$_.name}} | Restart-Computer -Force

#Example - ByPropertyName
new-alias -name 'PatFeder' -Value Get-Date
New-Item alias.csv -ItemType file
Add-Content alias.csv "Name, Value", "d, get-childitem", "sel, select-object"

#note that new-alias accepts -Name ByPropertyName and -Value ByPropertyName.  So we can create objects with these two properties
help new-alias -full
import-csv alias.csv
import-csv alias.csv | gm #We see that our object 
import-csv alias.csv | new-alias
Get-Alias

#This will work #ByValue
notepad.exe
Get-process note* | stop-process

#Here's why it works as ByValue.  We see the object types are the same
Get-process note* | gm
help stop-process -full

#ByPropertyName 
#Technically one command outputs objects with a -name property and the 2nd command accepts input by property
#however the process names aren't the same as service names
get-process -name spo* | stop-service
get-process -name spo* | gm
help stop-service -full

New-Item newusers.csv -ItemType file -Force
Add-Content newusers.csv "login, dept, city, title", "MATC1, IT, Milwaukee, NoBody", "MATC2, IT, Milwaukee, SomeBody"
notepad newusers.csv


import-csv NewUsers.csv | ft
help new-aduser 
import-csv C:\NewUsers.csv | new-aduser #won't work new-aduser requires samAccountname and Name

import-csv NewUsers.csv | Select-Object *, #the comma indicates that we're continuing the list or propeties
@{name='samAccountName'; expression ={$_.login}},`  #Hashtables consist of Key/Value pairs
@{n='Name';e ={$_.login}},`
@{n='Department';e ={$_.Dept}}

import-csv NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser 

#delete ad users  (is this byValue or byProperty?)
get-aduser -Filter 'Name -like "MATC*"'| Remove-ADUser

#did some research to set password and enable account -
#http://www.windowsnetworking.com/articles-tutorials/windows-server-2012/creating-active-directory-accounts-using-powershell.html
import-csv NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

#messing around... get-aduser -filter specifies query string that retrieves AD objects
New-ADOrganizationalUnit -Name "ITNetworkSpecialist" -Path  "DC=ITNET, DC=pri"
get-aduser -filter 'name -like "MATC*"'
get-aduser -filter 'name -like "MATC*"' | Move-ADObject -TargetPath "OU=ITNetworkSpecialist,DC=ITNET, DC=pri"


get-aduser -filter * -SearchBase "OU=ITNetworkSpecialist, DC=ITNET, DC=pri"  #-searchbase specifies AD path
get-aduser -filter * -SearchBase "OU=ITNetworkSpecialist, DC=ITNET, DC=pri" |
Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru 

#Take what you have seen and disable all the users accounts in ITNetworkSpecialist

#Take what you have seen and delete all the users in ITNetworkSpecialist

