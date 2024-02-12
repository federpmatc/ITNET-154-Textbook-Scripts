Get-PSDrive

#CmdLets to see and manipulate the data in a PSDrive include an ‘item’ noun)
Get-Item Alias:
Get-Item /   #refers to the object
#On macOS and Linux we don't have drive letters.  The entire FS is mapped to  /
Get-ChildItem / #refers to the items within the object
Get-ChildItem / #Let's see what is in it

#Most items have properties, just like files and folders have properties
Get-ItemProperty /Users  #Items have properties
Get-ItemProperty /Users  | select *

New-Item -ItemType Directory -Name labs
New-item -ItemType File -Name labs\test.txt

Set-Item -Path labs\test.txt -Value "hello"  #not supported on mac
Add-Content -Path  ./labs/test.txt -Value "hello"

Get-Item Env:/PSModulePath
Get-Item Env:/PSModulePath | select *

Get-ChildItem -Path ~/Downloads -Filter *.txt #seems to be the best
Get-ChildItem -Path ~/Downloads/* -Include *.txt,*.pdf  #include supports multiple conditions
Get-ChildItem -Path ~/Downloads/* -Exclude *.txt -Filter D*

Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer
get-item -Path  Advanced
Set-ItemProperty -path Advanced -PSProperty DontPrettyPath -Value 1

#The Power of using the | in PowerShell - TS
Get-Service
#If you wanted just the names to be displayed, it would be very difficult in many environments
#However, in PowerShell
Get-Service | Where-Object status -EQ "Running"

#Now what if you only wanted to display their names?/
Get-Service | Where-Object status -EQ "Running" |Select-Object "DisplayName" 

#What if you wanted to count them?
Get-Service | Where-Object status -EQ "Running" |Select-Object "DisplayName" | Measure-Object

#Export  
Get-Process | Sort-Object -Property CPU -Descending | #end with a pipe it will pickup next line
Select-Object -First 3 | Export-Csv ~\process.csv   #property values become column headings

#Create several domain admins first if necessary
New-ADUser `
-AccountPassword (ConvertTo-SecureString "Password01" -AsPlainText -Force) `
-Name "Admin1" `
-Enabled $true `
-Path "CN=Users, DC=ITNET-112, DC=pri" `
-SamAccountName Admin1 `
-UserPrincipalName ("Admin1@ITNET-112.pri")

New-ADUser `
-AccountPassword (ConvertTo-SecureString "Password01" -AsPlainText -Force) `
-Name "Admin2" `
-Enabled $true `
-Path "CN=Users, DC=ITNET-112, DC=pri" `
-SamAccountName Admin2 `
-UserPrincipalName ("Admin2@ITNET-112.pri")

#Add Admin1 & Admin2 to Admin Groups
Add-ADGroupMember -Identity 'Domain Admins' -Members 'Admin1','Admin2'

Get-ADGroupMember -Identity "Domain Admins" | Set-ADUser -City "Milwaukee"

#pipe example with objects
notepad;notepad
get-process
get-process note*
get-process note* |Stop-Process -Confirm

notepad;notepad
get-process | Export-csV ~\processes.csv #we see way more data.  We could use select-object * to see all data
Get-ADUser -Filter * | export-csv $env:userprofile\users.csv  #might be helpful to be able to make edits

notepad ~\processes.csv
#first line is the type of object
#second line are properties
#each row there after is a an object with it's properties

Import-Csv ~\processes.csv | Where-Object name -like "note*"| Stop-Process 

#different format, same data as CSV.  
#People prefer to use CliXML because it can handle more complex data


Get-Process | Export-CliXML ~\procs.xml
Import-CliXML ~\procs.xml

#We have cmdlets that direct the output to various locations
#dir does the following
Get-ChildItem | Out-Host

#pipe output to a file
Get-ChildItem | Out-File ~\dir.txt

$printer = Get-Printer |Out-GridView -Title "Select a printer" -OutputMode Single | Select-Object -ExpandProperty name
Get-EventLog System  -Newest 5 -EntryType Error,Warning | Select-Object TimeGenerated, Source, Message | fl | Out-Printer -Name $printer

#pipe to gridview
#The Out-GridView cmdlet sends the output from a command to a grid view window where the output is displayed in an interactive table.
#Because this cmdlet requires a user interface, it does not work on Server Core installations of Windows Server Fun to play with.  
Get-ChildItem c:\ | Out-GridView
Get-alias | out-gridview -PassThru

#Export/Import vs get-content
#get-content will not parse, import parses data and puts back into a format similar to original
Get-Process | Sort-Object -Property CPU -Descending| Select-Object -First 5 | Export-Csv gp.txt
notepad gp.txt
get-content gp.txt
Import-Csv gp.txt
