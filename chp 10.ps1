#Formatting

Get-Process #the system has pre-defined rules that control the output (based on the object type)
Get-Service 

Get-Service | ft -AutoSize
Get-Service | ft -Wrap
Get-Service | ft -Property name,status -AutoSize
Get-Service |select -First 5| ft * -AutoSize #make the columns wide enough to display values w/o truncating

Get-Service |select -First 5| fl * #make the columns wide enough to display values w/o truncating

Get-Service | fw  -Column 5 #format wide displays a single property

Get-Service | Out-GridView -Title Services #you don't specify properties of the object to display
