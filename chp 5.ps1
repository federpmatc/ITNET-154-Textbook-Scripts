#A PSProvider is an adapter that takes some kind of data storage and makes it look like a drive.
Get-PSProvider

#The PS Provider creates the PSdrive.
Get-psdrive  
gci alias:
gci hkcu:
gci env:
gci c:
gci env: 

regedt32.exe
Get-ChildItem hkcu: #we see the child items (Keys) and their properties (or values)

#For the most part, the cmdlets you use with a PSDrive have the word Item somewhere in their noun
get-command -noun *item*

help get-item
#The Get-Item cmdlet gets the item at the specified location. 
#It does not get the contents of the item at the location unless you use a wildcard character (*) 
#to request all the contents of the item.

#It's easiest to start with the FileSystem Provider
#Item refers to individual objects like files and folders
get-item -path C:\

get-childitem -path C:\ #returns child items at the location
get-childitem -path alias:    #access aliases

Get-Item -path HKCU: #returns the HKCU Key
get-childitem -path HKCU:   #returns the child items in this key, which are the subkeys and their associated values
Get-ItemProperty HKCU:\Environment

#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-5.1
#The PowerShell environment provider lets you access environment variables in a PowerShell drive (the Env: drive). 
gci Env:
Get-Item Env:USERPROFILE

#The following creates a file and a folder.
New-Item -path $env:USERPROFILE\"p2.txt" -ItemType file  #"c:\users\admin\Test2.txt" 
Set-Item -path $env:USERPROFILE\"p2.txt" -Value "hello" #This will not work.

#https://ss64.com/ps/syntax-esc.html
New-Item -path $env:USERPROFILE\Test3.txt -Value "hello"
New-Item -path $env:USERPROFILE\Test6.txt -Value "hello`r`nhello`r`n hello" -Force

New-Item -path $env:USERPROFILE\Test3 -Type directory
#Note: mkdir is a function that calls New-Item with the '-type directory' parameter

#Create an empty file
New-Item -ItemType file -path $env:USERPROFILE\example.txt
Get-Item -path $env:USERPROFILE\example.txt
Get-ItemProperty -path $env:USERPROFILE\* #Return the properties of all of the items, we see that wildcards are permitted

#Registry Provider
#The registry is divided into Keys and Values
#Think of Key <-> Folder and Value <-> File 
#A Key has properties associated with it, which are all of the values that we see
#Disable CTRL+ALT+Delete Requirement
#This setting allows a user to just type in his or her username and password without having to use the CTRL+ALT+Delete combination keys.

#The following example came from 
#https://www.petri.com/registry-and-tweaks-for-server-2008-as-a-workstation
#Do the following along side regedit


#Set location to appropriate Key
Set-Location -Path HKLM:\SOFTWARE\Microsoft\windows\CurrentVersion\Policies\System

#Open Regedit, which will make the following commands make more sense
regedt32
#So the current item is the System Key (or Folder)
Get-item -Path HKLM:\SOFTWARE\Microsoft\windows\CurrentVersion\Policies\System   #returns the item & associated values

Get-childitem -Path HKLM:\SOFTWARE\Microsoft\windows\CurrentVersion\Policies\System  #returns the child items (i.e. Keys)

#Windows 10 has CTRL-ALT-DEL disabled by default
#Server2012R2 has CTRL-ALT-DEL enabled by default

Set-ItemProperty -Path . -Name Disablecad -value 0  #1 = disabled Ctrl-Alt-Del; 0= enable CTRL-ALT-DEL

#Look at Value in this 'Key'
Get-item -Path HKLM:\SOFTWARE\Microsoft\windows\CurrentVersion\Policies\System   #returns the item & associated values

#Now lock the screen and verify 1 = disabled Ctrl-Alt-Del; 0= enable CTRL-ALT-DEL

#https://stackoverflow.com/questions/9368305/disable-ie-security-on-windows-server-via-powershell
#walk thru disable UAC & IE ESC

    
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Get-Item $AdminKey
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force

#Windows Explorer (Explorer.exe) is a program manager process that provides the graphical interface you use to interact with most of Windows—the Start menu, taskbar, notification area, and File Explorer
#Restarting Windows Explorer can also be handy if you’ve just installed a new app or applied a Registry tweak that would normally require you to restart your PC
Stop-Process -Name Explorer -Force
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green

#Disable UAC
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 #-Force
