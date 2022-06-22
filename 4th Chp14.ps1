#Chapter 14

#Process vs Thread

#Create a Process Job
Start-Job {
    Get-Service | Select-Object name,status
    }
 
Get-Job  #there's a HasMoreData property

Receive-Job -id 9

#Creating a Process Job
Start-ThreadJob -ScriptBlock { Get-ChildItem}

receive-job -id 7 -Keep
 
#Remoting as a job
Invoke-Command -ScriptBlock {hostname} -ComputerName Server2019-1,W10-Client -AsJob

#Invoke-Command Added the PSComputerName property
Invoke-Command -ScriptBlock {Get-Service | Select-Object -First 2} -ComputerName Server2019-1,W10-Client -AsJob
start-job -Name ThisWillFail -ScriptBlock {this is dumb}

get-job | Out-GridView
get-job -Id 22 | select *
     
Invoke-Command -ComputerName Server2016-2, client1 -asjob -JobName ThisWillFail -ScriptBlock {
    this is dumb; d}

#Managing jobs

#Remove-Job - deletes a job and any output still cached in memory
get-job | Remove-Job
    
$sb = Get-PSDrive | ?{$_.Free -gt 1} | %{$Count = 0; Write-Host "";} { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}{Write-Host"";Write-Host "Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}

