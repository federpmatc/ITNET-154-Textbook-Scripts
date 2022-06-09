#Q1
New-Item -ItemType Directory -Name labs

New-item -ItemType File -Name labs\test.txt

Set-Item -Path .\labs\test.txt -Value "hello"

Get-Item Env:Path
Dir Env:Path 
Gci Env:Path

gci -Path Desktop -Filter *.txt
gci -Path Desktop -Exclude *.txt
Get-ChildItem -Path C:\Users\Admin.ITNET\Desktop\* -Include *.rtf

Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer
get-item -Path  Advanced
Set-ItemProperty -path Advanced -PSProperty DontPrettyPath -Value 1

Set-Location C:\Users\Admin.ITNET\labs
Add-Content -Path .\test.txt -Value "Hello" 

notepad .\test.txt
