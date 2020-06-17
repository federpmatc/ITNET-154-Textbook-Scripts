#Chapter 3

#The first time you try to get help..nothing
get-help get-service -Examples

#Update-Help updates the help for all installed modules
#in a location listed in the $env:PSModulePath environment variable

update-help  #as user
update-help  #as admin

get-help get-service -Examples
get-help get-service  -Full
get-help get-service -online #

help Get-Disk -Examples

#I prefer just googling powershell get-service
#help & get-help are basically the same, help is a function that pipes the output of get-help to more

help *service #talk about wild cards

help Get-EventLog -Full

# We see that Get-Eventlog actually outputs 2 different types of info.
Get-EventLog -AsString #-AsString is a switch.
Get-EventLog -logname system
Get-EventLog  system #-logname is a positional parameter

Get-EventLog system -Newest 20 -InstanceId 20003 #-newest is an optional paramter

#The following requires that Remote Registry service be started on M410-Boss & Firewall off & PowerShell run as admin
#get-service RemoteRegistry | Start-Service

#OK Class retrieve the 5 newest entries from the System Log on M410-Boss

#region 
Get-EventLog -ComputerName m410-Boss -LogName System -Newest 5
#endregion 


New-Item -path "c:\servers.txt"  -ItemType file # -Value "Server2016-1`r`nServer2016-2`r`nLocalhost"
add-content -Path "c:\servers.txt" -Value "Server2016-1","Server2016-2", "localhost"
get-content C:\servers.txt
notepad C:\servers.txt 

Get-Content "C:\servers.txt"

#The -Computername paramter uses RPC, Remote Registry Service Running and requires Firewall turned off or at least port 445 open
New-NetFirewallRule -DisplayName Open445 -Direction Inbound -Action Allow -Protocol tcp -LocalPort 445 
#gsv RemoteRegistry | Start-Service
#Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Get-EventLog -LogName System -ComputerName server2016-2 -Newest 3
Get-EventLog -LogName System -ComputerName (Get-Content C:\servers.txt) -Newest 3

#Chapter 4
#####################################################################################
#get-command is designed to retrieve only commands

get-command get-se*
get-command -verb get
gcm -Noun service
gcm -CommandType Function



#4.3 cmdlet, function, application
#cmdlet is a PowerShell Command
#Function are written in PowerShell
#Application is an external command

#function
Function Get-MyName
{
Write-Host "This is a function"
Write-Host "My Name is Earl"
}

Get-MyName

Function Get-NewFiles
{
 $Start = (Get-Date).AddMonths(-1)
 $files = get-childitem -Path c:\*.* 
 $files | Where-Object LastWriteTime -gt $Start
}

get-newfiles

############## Aliases 4.4
get-command *alias*
get-command -commandtype alias
get-command -commandtype cmdlet

#http://xahlee.info/powershell/aliases.html 
Get-Alias
gal s*
gal -Definition get*
get-alias -definition get-command
get-alias gcm

#############
gcm *copy*
help Copy-Item

#region Challenge
New-Item c:\pat -ItemType directory
Copy-Item C:\Windows\ADWS\* -Destination C:\pat -Recurse
Get-ChildItem c:\pat -Recurse
#endregion




