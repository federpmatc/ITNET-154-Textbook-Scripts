#Hash tables consist of key/value pairs
#https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.5
$number = 1
$number 

$Class = "ITNET-154"
$Class | Get-Member

$Classes = "ITNET-154","ITNET-198", "ITNETN-199"
$Classes
$classes[1]

#Key/Value pairs
$name = @{"FullName"="Pat Feder";"ID" = 123456; age = 57}

$name
$name.keys

$name.FullName
$name['FullName']
$name.age

$names = @{"FullName"="Pat Feder"; "ID" = 123456; age = 55},
@{"FullName"="Jeanene Feder"; "ID" = 789; age = 54},
@{"FullName"="Yamaha Feder"; "ID" = "abcdef"; age = 30}

$names

$example = @{
    label='Size(MB)'
    expression={$_.Length / 1MB -as [int]}
}
$example

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 2| 
Select-Object Name, Length

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 4 |
 Select-Object Name, Length | ForEach-Object {
    Write-Host "Pat Feder says the FileName is: ", $_.Name}

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 2| 
Select-Object -Property Name , @{label='Size(MB)';expression={($_.Length / 1MB)}}
