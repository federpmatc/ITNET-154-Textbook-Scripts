#Chapter 15
Start-Job {
Get-CimInstance Win32_Service | Select-Object name,state,startmode,startname
}

start-job {dir c:\
gsv}

Get-Job   #there's a HasMoreData property
receive-job -Id 5

receive-job -id 7 -Keep

get-job -id 11 | select *

start-job -Name ThisWillFail -ScriptBlock {this is dumb; dir}
get-job
get-job -Id 13 | select *
Receive-Job -Id 13
Receive-Job -id 14
 
Invoke-Command -ComputerName Server2016-2, client1 -asjob -JobName ThisWillFail -ScriptBlock {this is dumb; dir}       
Get-Job -id 23 | Select-Object  -ExpandProperty childjobs

get-job -id 25
Receive-Job -Id 25
Receive-Job -Id 24
Receive-Job -id 23

Receive-Job -Id 26
