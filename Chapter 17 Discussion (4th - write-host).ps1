#Chapter 19 (write-host)
#https://stackoverflow.com/questions/19754069/powershell-difference-between-write-host-and-write-output#:~:text=In%20a%20nutshell%2C%20Write%2DHost,is%20implicitly%20called%20for%20you.

Write-Host "Hello World" -ForegroundColor Blue  #write host writes directly to hosting application, so we have more control
Write-Output "Hello World"   #write-output sends info to pipeline (no optiopns for formatting)

#PowerShell has a few otherways to produce output
$InformationPreference = 'Continue'  #configuration variable
Write-Information "Hello World"  #write to information stream

#When events occur (like errors, they are sent to the approriate stream)
$ErrorActionPreference = 'Continue'  #Configuration variables control what happens
Write-Error "Hello World"  #write to Error stream

$ErrorActionPreference = 'SilentlyContinue'  #Configuration variables control what happens
Write-Error "Hello World"  #write to Error stream

$VerbosePreference = 'Continue'
Write-Verbose "Hello World"  #write to Error stream


#More fun with the pipeline!
$a = 'Testing Write-OutPut'  | Write-Output
$b = 'Testing Write-Host' | Write-Host   #nothing goes to pipeline

$a
$b   #equal to null, because nothing is added to pipeline. Output goes directly to hosting application

#https://ss64.com/ps/tee-object.html
#tee-object Send the input object(s) to two places, an input object is piped to a file or variable, and then also passed along the pipeline.
get-process | Out-File -filepath ~\fileA.txt -Force
get-process | tee-object -filepath ~\fileA.txt 

get-process | tee-object -Variable tempvar   #send outout to a variable
$tempvar
get-process | tee-object -filepath ~\fileA.txt | out-file ~\fileB.txt

get-process  | tee-object -variable proc | select-object processname,handles
$proc
