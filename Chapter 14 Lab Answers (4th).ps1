#Chapter 14 answers
start-job {Get-ChildItem c:\users  *.ps1 -Recurse}

Get-Job
Receive-Job -Id 11
Get-Volume | Select-Object driveletter,size
#Doesn't return the PSComputerName property
start-job  -ComputerName server2019-1, W10-Client {
    Get-Volume | Select-Object driveletter,size
 }

 #PSComputerName
 Invoke-Command -ComputerName Server2019-1,W10-Client {
    Get-Volume | Select-Object driveletter,size, PSComputerName
 } -AsJob
 Get-Job | Select-Object *| Out-GridView
 Receive-Job -id 25 -Keep

 Get-Job | Remove-Job
