#1 Get all files in your C:\Windows or /usr directory that have a two-digit number as
part of the name
Get-ChildItem c:\windows | Where-Object {$_.name -match "\d{2}"}
Get-ChildItem /usr | where-object {$_.name -match "\d{2}"}

#2 Find all modules loaded on your computer that are from Microsoft, and display 
#the name, version number, author, and company name. (Hint: Pipe Get-module to Get-Member to discover property names.)
get-module | where-object {$_.companyname -match "^Microsoft"} | Select-Object Name,Version,Author,Company

#3 In the C:\Windows\Logs\CBS\CBS.log log, you want to display only the lines that contain update
Get-Content C:\Windows\Logs\CBS\CBS.log |  Select-string "[\w+\W+] Update" | Out-GridView
Get-Content C:\Windows\Logs\CBS\CBS.log |  Where-Object {$_ -match "[\w+\W+] Update" } | Out-GridView

#4 Using the Get-DNSClientCache cmdlet, display all listings in which the Data property is an IPv4 address.

#You could get by with a pattern that starts with one to three numbers followed by a literal period, like this:
get-dnsclientcache | where-object { $_.data -match "^\d{1,3}\."}

#Or you could match an entire IPv4 address string:
get-dnsclientcache | where-object{ $_.data -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}

#5 If you are on a Linux (or Windows) machine, find the lines of the HOSTS file that contain IPV4 addresses.

#Note: modified for Windows and changed search to not start at first char of each line
Get-Content C:\Windows\System32\drivers\etc\hosts | where-object {$_ -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}  
Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | Out-GridView

