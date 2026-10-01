#Chapter 3

#The first time you try to get help on a new system..nothing
get-help Get-Item 
get-help Get-Item -examples
get-help Get-Item -online


#Update-Help updates the help for all installed modules
#in a location listed in the $env:PSModulePath environment variable

update-help  #as user
update-help  #as admin (required with Windows PowerShell)

get-help -name get-item -Examples
get-help get-item -Examples #positional parameter and a switch
get-item . #get the current directory
get-item  * #get the contents
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
  
Get-EventLog -ComputerName Server2022-1 -LogName System -Newest 5


help new-item
New-Item -path "~\servers.txt"  -ItemType file  -force #
set-content -Path "~\servers.txt" -Value "Server2022-1","Server2022-2", "W11-Client"
get-content ~\servers.txt
$servers = get-content ~\servers.txt
$servers
foreach ($server in $servers) {
    New-Item -Path "~\$server"  -ItemType file -Force
}

help about*   #background topics
#In PowerShell, "about_" topics are conceptual help articles that explain the fundamental principles, scripting language rules, and underlying mechanics 
#of the environment

help about_Aliases 
New-Alias -Name ghh -Value Get-Help

#Chapter 4 Running Commands
#####################################################################################
$diskInfo = 'Get-PSDrive | ?{$_.Free -gt 1} | %{$Count = 0; Write-Host "";} { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}{Write-Host"";Write-Host "Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}'
New-Item -path "~\DiskInfo.ps1"  -ItemType file  -force #
set-content -Path "~\DiskInfo.ps1"  -Value $diskInfo
Get-Content -Path "~\DiskInfo.ps1"

Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process #Run local scripts or downloaded scripts that are digitally signed
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process #Scripts aren't executed


#4.3 cmdlet, function, application
#cmdlet is a PowerShell Command (verb-noun)
#Function are written in PowerShell
#Application is an external command (like ping)
#Alias is like a shortcut (gci)

#function
Function GetMyName
{
Write-Host "This is a function"
Write-Host "My Name is Earl"
}

GetMyName

Function Get-NewFiles
{
    $date = get-date
    $Start = $date.AddMonths(-6)
    write-host "current:$date and 6 months ago $start"
    get-childitem -Path ~ | Where-Object LastWriteTime -gt $Start
}

get-newfiles

get-command *alias*
get-command -commandtype alias
get-command -commandtype cmdlet

#http://xahlee.info/powershell/aliases.html 
Get-Alias
Get-Alias  -name s*
Get-Alias -Definition get*
Get-Alias -Definition *item*
get-alias -definition get-command


#############
get-command *copy*
help Copy-Item
#Look at the examples how do I copy one directory (and it's contents) to another directory?

Get-Item ~\Documents\*

#region Challenge
New-Item -path "~\temp" -ItemType directory
Copy-Item -path ~\Documents\* -Destination ~\temp  -Recurse
Get-ChildItem ~\temp -Recurse
#endregion

#rewrite the above with aliases

#Support External Commands
ping  -n 20 8.8.8.8

$exe = "ping"
$count = 5
$address = "8.8.8.8"

& $exe -n $count $address   #Invocation Operator, variables, external commands

$myHashtable = @{
    "Key1" = "Value1"
    "Key2" = "Value2"
    "Key3" = "Value3"
}
$myHashtable
$myHashtable.Key1
$myHashtable['Key1'] 

#Splatting
$NewItemParams = @{
    path = "~\servers.txt"
    ItemType = "file"
    Force = $true
}

New-Item @NewItemParams

