#Chapter 3

#The first time you try to get help on a new system..nothing
get-help Get-Item -Examples

#Update-Help updates the help for all installed modules
#in a location listed in the $env:PSModulePath environment variable

update-help  #as user
update-help  #as admin (required with Windows PowerShell)

get-help -name get-item -Examples
get-help get-item -Examples #positional parameter and a switch
get-item . #get the current directory
get-item * #get the contents
get-item -Path ~\*

help get-item  -Full
help get-item -online #

#I prefer just googling powershell get-service
#help & get-help are basically the same, help is a function that pipes the output of get-help to more

help *item* #talk about wild cards


# We see that Get-Eventlog actually outputs 2 different types of info.
Get-EventLog -AsString #-AsString is a switch.
Get-EventLog -logname system 
Get-EventLog  system #-logname is a positional parameter
Get-EventLog -logname system -Newest 20 -InstanceId 20003 #-newest is an optional paramter

#The following requires that Remote Registry service be started & Firewall off & PowerShell run as admin
#get-service RemoteRegistry

#region 
Get-EventLog -ComputerName Server2019-1 -LogName System -Newest 5
#endregion 

help new-item
New-Item -path "~\servers.txt"  -ItemType file  -force #
add-content -Path "~\servers.txt" -Value "Server2019-1","Server2019-2", "W10-Client"
get-content ~\servers.txt

help about*   #background topics
help about_Aliases
New-Alias -Name ghh -Value Get-Help

#Chapter 4 Running Commands
#####################################################################################
$diskInfo = 'Get-PSDrive | ?{$_.Free -gt 1} | %{$Count = 0; Write-Host "";} { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}{Write-Host"";Write-Host "Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}'
New-Item -path "~\DiskInfo.ps1"  -ItemType file  -force #
add-content -Path "~\DiskInfo.ps1"  -Value $diskInfo
Get-Content -Path "~\DiskInfo.ps1"

Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  #Run local scripts or downloaded scripts that are digitally signed
Set-ExecutionPolicy -ExecutionPolicy Restricted  #Scripts aren't executed


#4.3 cmdlet, function, application
#cmdlet is a PowerShell Command (verb-noun)
#Function are written in PowerShell
#Application is an external command (like ping)
#Alias is like a shortcut (gci)

#function
Function Get-MyName
{
Write-Host "This is a function"
Write-Host "My Name is Earl"
}

Get-MyName

Function Get-NewFiles
{
 $Start = (Get-Date).AddMonths(-6)
 get-childitem -Path ~ | Where-Object LastWriteTime -gt $Start
}

get-newfiles

get-command *alias*
get-command -commandtype alias
get-command -commandtype cmdlet

#http://xahlee.info/powershell/aliases.html 
Get-Alias
gal s*
gal -Definition get*
gal -Definition *item*
get-alias -definition get-command
get-alias -Name g*

#############
get-command *copy*
help Copy-Item
#Look at the examples how do I copy one directory (and it's contents) to another directory?

Get-Item ~\Documents\*

#region Challenge
New-Item ~\temp -ItemType directory
Copy-Item ~\Documents\* -Destination ~\temp # -Recurse
Get-ChildItem ~\temp #-Recurse
#endregion

#rewrite the above with aliases

#Support External Commands
ping -c 20 8.8.8.8

$exe = "ping"
$count = 5
$address = "8.8.8.8"

& $exe -c $count $address   #Invocation Operator, variables, external commands
