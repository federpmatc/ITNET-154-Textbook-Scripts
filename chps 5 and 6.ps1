Write-Host "Chapter 5 and 6 Answers"
#Q1-4
New-Item -ItemType Directory -Name labs -Path ~
New-Item -ItemType File -Name ZeroLengthFile -Path ~\labs
Set-item -Path ~\labs\ZeroLengthFile -Value "This is a test"
Get-ChildItem Env: | Out-GridView

Set-Location ~
Set-Location $HOME  #automatic variable that contains path to user home directory
Set-Location $env:HOMEPATH  #special prefix to access environment variables

#q5
1..5| ForEach-Object {New-Item -ItemType File "file$_.txt"}
1..5| ForEach-Object {New-Item -ItemType File "file$_.pdf"}
1..5| ForEach-Object {New-Item -ItemType File "file$_.csv"}

gci -Path ~\*
gci -Path ~\* -Include *.pdf
gci -Path ~ -Exclude *.pdf


Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer
Set-ItemProperty -Path .\Advanced\ -Name "DontPrettyPath" -Value 1

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "DontPrettyPath" -Value 1
Get-ChildItem -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer 
Get-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
Get-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name DontPrettyPath

Set-Location "C:\~"

New-Item -ItemType File -Name ZeroLengthFile -Path ~\labs -Value "Hello" -Force
Add-Content -Path ~\labs\ZeroLengthFile -Value "Hello Again"
Get-Content -path ~\labs\ZeroLengthFile
Set-Location ~\labs
notepad.exe .\ZeroLengthFile 

#Chapter 6
Set-Location "C:\~"
New-Item -ItemType File -Name File1 -Value "Hello" -Force
New-Item -ItemType File -Name File2 -Value "Hello Again" -Force
diff -ReferenceObject (Get-Content file1) -DifferenceObject (Get-Content file2)
Compare-Object -ReferenceObject (Get-Content file1) -DifferenceObject (Get-Content file2)

get-service | Out-GridView

Get-Service wuauserv | Stop-Service
Stop-Service -Name "Windows Search"

get-service | Out-GridView | export-csv srvcs.csv
get-service |  export-csv srvcs.csv

get-service |  export-csv srvcs.csv -Delimiter "|"

get-service w* |  export-csv srvcs.csv -IncludeTypeInformation

get-service w* |  export-csv srvcs.csv -IncludeTypeInformation -NoClobber

get-service w* |  export-csv srvcs.csv -IncludeTypeInformation -NoClobber -UseCulture




