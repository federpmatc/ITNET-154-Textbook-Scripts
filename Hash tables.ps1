#Hash tables consist of key/value pairs
#https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.5

$name = @{"FullName"="Pat Feder"
    "ID" = 123456
    age = 55
}
$name
$name.FullName
$name['FullName']
$name.age

$names = @{"FullName"="Pat Feder"; "ID" = 123456; age = 55},
@{"FullName"="Jeanene Feder"; "ID" = 789; age = 54},
@{"FullName"="Yamaha Feder"; "ID" = abcdef; age = 30}

$names



@{label='Size(MB)';expression={$_.Length / 1MB -as [int]}}

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 2
| Select-Object Name, Length, LastWriteTime | select-objcect name,length

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 2
| Select-Object Name, Length, LastWriteTime | ForEach-Object {
    Write-Host "FileName: ", $_.Name
    write-Host "FileSize: ", (($_.length)/1MB)}

Get-ChildItem ~ -Recurse | sort-object -Property Length -Descending | Select-Object -First 2
| Select-Object Name, Length, 
@{label='Size(MB)';expression={($_.Length / 1MB)}}

