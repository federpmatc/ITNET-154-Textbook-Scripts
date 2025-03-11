#Chapter 14
#Process vs Thread
#Create a Process Job
#Creating a process requires more overhead vs thread
#There's a limit to the number of threads that can be started (10)

measure-command {Get-ChildItem c:\  -recurse | Sort-Object -Property length  } #Some jobs take a while1
start-job {Get-ChildItem c:\ -Recurse | Sort-Object -Property Length |Select-Object Name,Length}
Start-ThreadJob {Get-ChildItem c:\ -Recurse | Sort-Object -Property Length | Select-Object Name,Length}

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
Invoke-Command -ScriptBlock {hostname} -ComputerName Server22-01,Win11-Client -AsJob  #Note -ComputerName is for Windows Computers and -hostname is for SSH (typically Mac/Linux)


#Invoke-Command Added the PSComputerName property
Invoke-Command -ScriptBlock {Get-Service | Select-Object -First 2} -ComputerName Server22-01,Win11-Client -AsJob
Get-job -id 16 | Format-list
Get-job -id 16 | Select-Object -ExpandProperty ChildJobs  #return info about the childjobs that were created.  Could use Get-Member to explain
Receive-Job -id 16

start-job -Name ThisWillFail -ScriptBlock {this is dumb}

get-job | Select-Object * | Out-GridView
get-job -Id 57 | Select-Object *   #Note this receives Job Info (not the data)

#Managing jobs

#Remove-Job - deletes a job and any output still cached in memory
get-job | Remove-Job
    
$sb = {Get-PSDrive | where-object {$_.Free -gt 1}}
Invoke-Command -ScriptBlock $sb -ComputerName Server22-01,Win11-Client -AsJob
Get-Job 
Receive-Job 59


$sb = {Get-PSDrive | ?{$_.Free -gt 1} | %{$Count = 0; Write-Host "";} { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}{Write-Host"";Write-Host "$env:Computername has a Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}}

Get-PSDrive | ?{$_.Free -gt 1} | %{$Count = 0; Write-Host "";} { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}{Write-Host"";Write-Host "$env:Computername Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}

Invoke-Command -ScriptBlock $sb -ComputerName Server22-01,Win11-Client -AsJob

Receive-Job -id 3
