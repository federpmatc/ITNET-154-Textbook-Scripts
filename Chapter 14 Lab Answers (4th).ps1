#Chapter 14 answers
start-job {Get-ChildItem c:\users  *.ps1 -Recurse}

Get-Job
#make sure to change the job id below as needed
Receive-Job -Id 7

Get-Volume | Select-Object driveletter,size

 #PSComputerName
 Invoke-Command -ComputerName Server22-01,Win11-Client {
    Get-Volume | Select-Object driveletter,size, PSComputerName
 } -AsJob

 Get-Job | Select-Object *| Out-GridView
 Receive-Job -id 20 -Keep

 Get-Job | Remove-Job
