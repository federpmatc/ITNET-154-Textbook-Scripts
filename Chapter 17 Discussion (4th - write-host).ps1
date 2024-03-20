#Chapter 17 (write-host)
#https://stackoverflow.com/questions/19754069/powershell-difference-between-write-host-and-write-output#:~:text=In%20a%20nutshell%2C%20Write%2DHost,is%20implicitly%20called%20for%20you.
#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams?view=powershell-7.4

#PowerShell provides multiple output streams. The streams provide channels for different types of messages. 
#You can write to these streams using the associated cmdlet or redirection. 

#Write-Host is a wrapper for Write-Information This allows you to use Write-Host to emit output to the information stream. 
#This enables the capture or suppression of data written using Write-Host while preserving backwards compatibility.
Write-Host "Hello World" -ForegroundColor Blue -BackgroundColor Yellow #write host writes directly to hosting application, so we have more control
Write-Output "Hello World"   #write-output sends info to pipeline (no optiopns for formatting)
"hello world"

#PowerShell has a few otherways to produce output
$InformationPreference = 'continue' #configuration variable
Write-Information "Hello World"  #write to information stream

#When events occur (like errors, they are sent to the approriate stream)
$ErrorActionPreference = 'continue'  #Configuration variables control what happens
Write-Error "Hello World"  #write to Error stream

$ErrorActionPreference = 'SilentlyContinue'  #Configuration variables control what happens
Write-Error "Hello World"  #write to Error stream

#The Write-Verbose cmdlet writes text to the verbose message stream in PowerShell. 
#The verbose message stream is used to deliver more in depth information about command processing.
#By default, the verbose message stream is not displayed, but you can display it by changing the value of the $VerbosePreference variable or using the Verbose common parameter in any command.

$VerbosePreference = 'SilentlyContinue'
Write-Verbose "line 15"  #write to Error stream


#More fun with the pipeline!
$a = get-process  | Write-Output
$b = Get-Process | Write-Host   #nothing goes to pipeline.  Data is sent directly to information stream

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
