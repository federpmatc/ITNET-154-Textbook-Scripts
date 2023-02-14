New-Item -Name "TestFolder" -Path ~/ -Force -ItemType "Directory"
1..10 | ForEach-Object { New-Item -Name "File-$_" -Path ~/TestFolder -Force -ItemType "File" }

#Variables - Quick Review
get-process | Select-Object name | Out-File -FilePath ~\file1.txt
notepad.exe
get-process | Select-Object name | Out-File -FilePath ~\file2.txt

$f1 = get-content ~\file1.txt
$f2 = get-content ~\file2.txt

diff -ReferenceObject $f1 -DifferenceObject $f2

"SRV-02" | Get-Member
$var = "SRV-02"

gps powershell
$procID = "3552"            #set to ID
get-process -Id $procID
$procID | gm

$procID = 3552
$procID | gm

#Quotes
'The process ID is $procID'
"The process ID is $procID"

$env:COMPUTERNAME
$computername = "Pats Desktop"
$phrase = "$computername is equal to $computername"
$phrase

$phrase = "`$computername is equal to $computername"
$phrase
$phrase = "`$computername`ncontains`n$computername"
$phrase
$phrase.ToUpper()
$phrase.ToLower()
$phrase.Replace('contain',"like it's got")

###Convert files to uppercase
###Could I add the date to each file??
Get-ChildItem | Select-Object -ExpandProperty name 
Get-ChildItem | Select-Object -ExpandProperty name  | ForEach-Object {"hello"}
Get-ChildItem | Select-Object -ExpandProperty name  | ForEach-Object {$_.toupper()}

Get-ChildItem | ForEach-Object {
Write-Host "The file name is $($_.Name)"
}

#Help about escape characters

#Collection of objects
$computers = 'SRV-02','SERVER1','localhost'
$computers.Length
$computers[0].Length

$computers.count

#variable types
$number = Read-Host "Pick a number"
$answer = "10" * $number
write-host $number "* 10 equals" $answer  #????

[int]$number  = Read-Host "Pick a number"
$number
$number*10  #:)

