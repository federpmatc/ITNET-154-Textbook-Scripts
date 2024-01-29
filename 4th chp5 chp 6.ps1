Get-PSDrive

#CmdLets to see and manipulate the data in a PSDrive include an ‘item’ noun)
Get-Item Alias:
Get-Item /   #refers to the object
#On macOS and Linux we don't have drive letters.  The entire FS is mapped to  /
Get-ChildItem / #refers to the items within the object
Get-ChildItem / #Let's see what is in it

#Most items have properties, just like files and folders have properties
Get-ItemProperty /Users  #Items have properties
Get-ItemProperty /Users  | select *

New-Item -ItemType Directory -Name labs
New-item -ItemType File -Name labs\test.txt

Set-Item -Path labs\test.txt -Value "hello"  #not supported on mac
Add-Content -Path  ./labs/test.txt -Value "hello"

Get-Item Env:/PSModulePath
Get-Item Env:/PSModulePath | select *

Get-ChildItem -Path ~/Downloads -Filter *.txt #seems to be the best
Get-ChildItem -Path ~/Downloads/* -Include *.txt,*.pdf  #include supports multiple conditions
Get-ChildItem -Path ~/Downloads/* -Exclude *.txt -Filter D*

Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer
get-item -Path  Advanced
Set-ItemProperty -path Advanced -PSProperty DontPrettyPath -Value 1
