New-Item -Path ~ -Name test -ItemType Directory #create a directory
new-item -Path ~/test -Name Pat1.txt #create a file in the directory created above
new-item -Path ~/test -Name Pat2.txt
new-item -Path ~/test -Name Pat3.txt
new-item -Path ~/test -Name MATC1.txt
new-item -Path ~/test -Name MATC2.txt
new-item -Path ~/test -Name MATC3.txt

Get-ChildItem -Name ~/test   #returns all files
Get-ChildItem -Name ~/test -Filter *   #returns all files (same as above)

Get-ChildItem -Name ~/test -Filter p* #returns all files that start with p
Get-ChildItem -Name ~/test -Filter p* -Exclude *1.txt  #exclude all files that end with 1.txt

Get-ChildItem -Name ~/test -Filter p* -Include *1.txt  #include only the files that start with 'p' and end with 1.txt
Get-ChildItem -Name ~/test -Filter * -Include *1.txt  #include only the files that end with 1.txt

Get-Process | Export-Csv -IncludeTypeInformation -Path ~/test.csv 

Get-ChildItem | Get-Random -Count 2

#https://www.itprotoday.com/powershell/how-use-powershell-create-pdf-files
Get-ChildItem *.txt | Select-Object Name,LastWriteTime
Get-ChildItem *.txt | Select-Object Name,{$_.CreationTime} 
Get-ChildItem *.txt | Select-Object Name,@{Name="Year"; Expression={$_.CreationTime.Year}}
Get-ChildItem *.txt | Where-Object { $_.Length -lt 50 }
Get-ChildItem *.txt | ForEach-Object { $_.Length, $_.Name}
Get-ChildItem *.txt | Foreach-Object {"{0} {1}" -f $_.CreationTime.Year, $_.Name} 
Get-ChildItem *.txt | Sort-Object -Property Length -Descending
Get-ChildItem *.txt -Recurse | Sort-Object -Property Length -Descending | Select-Object -First 5

Get-ChildItem *.txt | Measure-Object -property length -sum 
Get-ChildItem *.txt | Measure-Object -property length -sum | Select-Object sum, Property
