#1 
Get-ChildItem c:\windows | Where-Object {$_.name -match "\d{2}"}
Get-ChildItem /usr | where-object {$_.name -match "\d{2}"}

#2 
get-module | where-object {$_.companyname -match "^M.crosoft"} | Select-Object Name,Version,Author,Company

#3 
Get-Content C:\Windows\Logs\CBS\CBS.log |  Select-string "[\w+\W+] Update" | Out-GridView
Get-Content C:\Windows\Logs\CBS\CBS.log |  Where-Object {$_ -match "[\w+\W+] Update" } | Out-GridView

Get-content ./apt/history.log | select-string "[\w+\W+]Installing"

#4 
#You could get by with a pattern that starts with one to three numbers followed by a literal period, like this:
get-dnsclientcache | where-object { $_.data -match "^\d{1,3}\."}

#Or you could match an entire IPv4 address string:
get-dnsclientcache | where-object{ $_.data -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}

#5 
#modified for Windows.  Also removed changed search to not start at first char
Get-Content C:\Windows\System32\drivers\etc\hosts | where-object {$_ -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"}  

Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | Out-GridView

