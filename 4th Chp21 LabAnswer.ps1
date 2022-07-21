#1
Get-ChildItem c:\windows | where {$_.name -match "\d{2}"}
Get-ChildItem /usr | where {$_.name -match "\d{2}"}

#2 
get-module | where {$_.companyname -match "^Microsoft"} | Select Name,Version,Author,Company

#3 
get-content C:\Windows\WindowsUpdate.log |Select-string "[\w+\W+]Installing Update"
Get-content ./apt/history.log | select-string "[\w+\W+]Installing"

#4 
#You could get by with a pattern that starts with one to three numbers followed by a literal period, like this:
get-dnsclientcache | where { $_.data -match "^\d{1,3}\."}

#Or you could match an entire IPv4 address string:
get-dnsclientcache | where{ $_.data -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}

#5 
gc /etc/hosts | where {$_ -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}
