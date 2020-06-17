Get-date
Get-date | select *
Get-date | gm

#we see that this object contains ScriptProperty, Property, NoteProperty, method.  

#The different properties are still just properties.
#We can access Methods & Properties

$gdate = get-date 
$gdate | gm


$gdate.AddMonths(-1)
(get-date).AddDays(33)  #use the method to add 33 days

#You rarely will execute a method directly
notepad
$a = get-process -Name Notepad*
$a.Kill()

#much better to use a cmdlet to execute a method (this is what is normally done)
get-process -Name Notepad* | Stop-Process

#82
#Sort
get-process | Sort-Object -property VM  #(-property is a positional parameter), there’s also a -descending parameter
get-process | Sort-Object processname, ID #Sort by process name and then in case of a tie ID

#83
#select-object ... this selects the columns
get-process | Sort-Object processname, ID | Select-Object -First 5 
get-process | Sort-Object processname, ID | Select-Object ID, ProcessName,VM 
get-process | Sort-Object processname, ID | Select-Object ID, ProcessName,VM | ConvertTo-Html | Out-File "c:\pat.html"
get-process | Sort-Object processname, ID | Select-Object ID, ProcessName,VM | export-csv "c:\pat.csv"
get-process | Sort-Object processname, ID | Select-Object ID, ProcessName,VM | Out-GridView

Get-ADUser -Filter * -SearchBase "OU=Employees,DC=ad,DC=PEF4DRubrik,DC=com" | Sort-Object name -de

get-date | Out-GridView
get-date | Select-Object dayofweek

#Where-Object ... this selects the rows
get-process |gm
get-process | Where-Object CPU -gt .5

###########################Discuss
#Which one of these does not make sense?
Get-Process | ConvertTo-HTML 
Get-Process | Select-Object -Property Name | Sort-Object -Property Name -descending
Get-Process | Sort-Object -Property Name | Select-Object -Property Name
Get-Process | Select-Object Name,Id | Sort-Object VM -descending

#############################################
#What do you think the following returns?
$env:USERPROFILE
$myprofile = $env:USERPROFILE
Get-ChildItem $myprofile 

Get-ChildItem $myprofile
#Now modify the line above to accomplish the following
#Return only files
#Return only file (including those files found in sub-folders)
#Return the 5 files that were written last (i.e. Sort based on the last write time)

#8.1
#Identify a cmdlet that produces a random number

#Identify a cmdlet to pick a one of the following names at Random "Pat", "Brian", "Steve"

#8.2
#Identify a cmdlet that displays current date and time

#8.3
#What type of object gets returned from task above

#8.4
#command from 8.2 to display day of the week and year


