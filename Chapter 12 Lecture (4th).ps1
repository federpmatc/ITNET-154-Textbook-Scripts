#Comparison Operators & Filtering
#Comparison operators can be used to filter objects out of the pipeline
#Comparison involve 2 objects, values and testing their relationship

#11.3 Comparison Operators
#-eq, -ne, -ge, -le, -gt, -lt, -ceq, -like -notlike, -clike ...
5 -eq 5
5 -ne 5

(5 -lt 6) -and (12 -lt 10)
(5 -lt 6) -or (12 -lt 10)

#Comparing strings
"Pat" -eq "pat"
"Pat" -ceq "pat"
"Patrick" -like "pat"
"Patrick" -like "*at*"  #like operator allows *

#not
-not 5 -eq 5
-not (15 -lt 6) -or (2 -lt 10)
-not ((15 -lt 6) -or (2 -lt 10))

#11.4 Filtering objects out of pipeline with comparison operators
#Some command lets support -filter parameter, 
#We put the filter conditions in {scriptblock}

#the following cmdlets do the samething, however filtering left is better
Get-ADComputer -Filter {name -like 'Server*'} 
Get-ADComputer -Filter * | where name -like 'Server*'
Get-ADComputer -Filter * | where {$_.name -like 'Server*'} 

Get-Process | Where-Object {($_.Name -eq "iexplore") -or ($_.Name -eq "chrome") -or ($_.Name -eq "firefox")}
Get-Service | Where-Object -filter {$_.Status -eq "Running"} #-filter parameter is positional

#If you only have a single comparison .....
Get-Service | where status -ne "Running"

#What does the following code do?
Get-process | where-object {$_.name -notlike "*powershell*"} | 
sort-object vm -Descending | select -First 10 | measure-object -property VM -sum

#illustrates select & -expandProperty
get-adcomputer -filter * | where-object {$_.name -like "server*"} | select-object -expand name

#Script to find 10 largest files, illustrates two uses of select
gci ~ -Recurse -File  | sort Length -Descending |   select -First 2 | select name,length | ft -AutoSize

## Homework
#3 on Windows VM you could search for all files larger than 5MB in C:\Windows\Fonts
gci C:\Windows\Fonts | Where-Object length -gt 5MB

#5 Get the files in the current directory where the LastWriteTime is in the last week. 
#(Hint: (Get-Date).AddDays(-7) will give you the date from a week ago.) 
gci ~ | Where-Object LastWriteTime -lt (Get-Date).AddDays(-7)

#7.   Display the 10 processes with the greatest amount of CPU time.  
#The process objects have a property called CPU.  
#You will need to use cmdlets like Get-Process &, Select-Object & Sort-Object# to accomplish this.
gps | Sort-Object CPU -Descending | Select-Object -First 2


