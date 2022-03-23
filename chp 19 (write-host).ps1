#Chapter 19 (write-host)
#https://stackoverflow.com/questions/19754069/powershell-difference-between-write-host-and-write-output#:~:text=In%20a%20nutshell%2C%20Write%2DHost,is%20implicitly%20called%20for%20you.

Write-Host "Hello World"

Write-Output "Hello World"

GSV
Get-Service | Write-Output

$a = 'Testing Write-OutPut'  | Write-Output
$b = 'Testing Write-Host' | Write-Host

$a
$b

#https://ss64.com/ps/tee-object.html
get-process | Out-File -filepath C:\fileA.txt -Force
get-process | tee-object -filepath C:\fileA.txt 

get-process | tee-object -filepath C:\fileA.txt | out-file C:\fileB.txt

notepad
get-process notepad | tee-object -variable proc | select-object processname,handles
$proc