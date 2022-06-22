#Chapter 14
#Process vs Thread
#Create a Process Job
Start-Job -scriptblock {
    Get-Service | Select-Object name,status | select -First 2
    }
 
Get-Job  #there's a HasMoreData property

Receive-Job -id 9

#Creating a Thread Job
Start-ThreadJob -ScriptBlock { 
    Get-ChildItem }

receive-job -id 7 -Keep
 
#Remoting as a job
Invoke-Command -ScriptBlock {hostname} -ComputerName Server2019-1,W10-Client -AsJob

#Invoke-Command Added the PSComputerName property
Invoke-Command -ScriptBlock {Get-Service | Select-Object -First 2} -ComputerName Server2019-1,W10-Client -AsJob
start-job -Name ThisWillFail -ScriptBlock {this is dumb}

get-job | Select-Object * | Out-GridView
get-job -Id 57 | Select-Object *

#Managing jobs

#Remove-Job - deletes a job and any output still cached in memory
get-job | Remove-Job
    
$sb = {Get-PSDrive | where-object {$_.Free -gt 1}}
Invoke-Command -ScriptBlock $sb -ComputerName Server2019-1,W10-Client -AsJob
Get-Job 
Receive-Job 59
