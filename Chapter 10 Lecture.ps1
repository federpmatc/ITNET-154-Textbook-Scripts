#PowerShell uses two methods to get the output of one command to another
#ByValue - looks at output object type and checks if input command has parameters that accept this TYPE of object
#ByPropertyname - Looks at output objects PROPERTIES and lines them up input object PARAMETERS

New-Item ~\computers.txt -ItemType file -Force
Add-Content -Path ~\computers.txt "Server2019-2", "W10-client"
Get-Content ~\computers.txt
Set-Location ~
notepad computers.txt

#Disable firewall on remote computer
Set-NetFirewallProfile -all -Enabled False

get-content ~\computers.txt

get-content ~\computers.txt | get-service
#let's figure out what went wrong

get-content ~\computers.txt | gm  #we see that the output object is a string

help get-service -full #-Name parameter is used to specify a service name

get-content ~\computers.txt | Restart-Computer -Confirm  -force #Computer Name
get-content ~\computers.txt | Test-Connection   #target name

#generate a string[] with computer names
Restart-Computer -confirm -ComputerName ("Server2019-1")
Restart-Computer -computername (get-content ~\computers.txt) -Confirm 
Test-Connection -TargetName (get-content ~\computers.txt)  


#Example - Converting Object Property to a string
Test-Connection -targetname ( get-adcomputer -filter * -SearchBase "CN=computers, dc=itnet, dc=pri" | select-object -expand name )

#Example
$computers = get-adcomputer -filter * -SearchBase "CN=computers, dc=itnet, dc=pri" | select  @{n='ComputerName';e={$_.name}}
$computers | Test-Connection #ByValue

#ByPropertyName
get-adcomputer -filter * -SearchBase "CN=Computers, dc=ITNET, dc=pri"
get-adcomputer -filter * -SearchBase "CN=Computers, dc=ITNET, dc=pri" | Test-Connection
get-adcomputer -filter * -SearchBase "CN=Computers, dc=itnet, dc=pri" |select  *,@{n='TargetName';e={$_.name}} | Test-Connection

get-adcomputer -filter * -SearchBase "CN=Computers, dc=itnet, dc=pri" |Select-Object  *,@{n='TargetName';e={$_.name}} | Restart-Computer -Confirm

#Example - ByPropertyName
new-alias -name 'PatFeder' -Value Get-Date
New-Item ~\alias.csv -ItemType file -Force
Add-Content ~\alias.csv "Name, Value", "d, get-childitem", "sel, select-object"

help new-alias -full #note that new-alias accepts -Name ByPropertyName and -Value ByPropertyName.  So we can create
import-csv ~\alias.csv
import-csv ~\alias.csv | gm #We see that our object 
import-csv ~\alias.csv | new-alias
 
New-Item ~\newusers.csv -ItemType file -Force
Add-Content ~\newusers.csv "login, dept, city, title", "MATC1, IT, Milwaukee, NoBody", "MATC2, IT, Milwaukee, SomeBody"
Set-Location ~
notepad newusers.csv


import-csv ~\NewUsers.csv | Format-List
help new-aduser 
import-csv ~\NewUsers.csv | new-aduser #won't work new-aduser requires samAccountname and Name

import-csv ~\NewUsers.csv | Select-Object *, #the comma indicates that we're continuing the list or propeties
@{name='samAccountName'; expression ={$_.login}},  #Hashtables consist of Key/Value pairs
@{n='Name';e ={$_.login}},
@{n='Department';e ={$_.Dept}} | format-table

import-csv ~\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser

#delete ad users
get-aduser -Filter 'Name -like "MATC*"'| Remove-ADUser -Confirm

#did some research to set password and enable account -
#http://www.windowsnetworking.com/articles-tutorials/windows-server-2012/creating-active-directory-accounts-using-powershell.html
import-csv ~\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

#messing around... get-aduser -filter specifies query string that retrieves AD objects
get-aduser -filter *
get-aduser -filter 'Name -like "MATC*"' |
Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru 

import-csv C:\NewUsers.csv |
Select-Object *, @{name='samAccountName';expression ={$_.login}}, @{n='Name';e ={$_.login}}, @{n='Department';e ={$_.Dept}} |
new-aduser -PassThru |Set-ADaccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) -PassThru | Enable-ADAccount

New-ADOrganizationalUnit -Name temp -Path "DC=ITNET, DC=pri"

get-aduser -filter 'Name -like "MATC*"' | Move-ADObject -TargetPath "OU=Temp, DC=ITNET, DC=pri"
#Take what you have seen and delete all the users in IT Support OU
get-aduser -filter * -SearchBase "OU=Temp, DC=ITNET, DC=pri" | Remove-ADUser
