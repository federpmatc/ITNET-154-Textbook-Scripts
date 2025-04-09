#Chapter 12
Get-Command -Module PSReadLine
Get-Command -Module PSReadLine -Verb get
Get-ChildItem -File -Path C:\Windows\Fonts | Where-Object {$_.length -ge 5MB}
Find-Module -name PS* |Where-Object {$_.author -like "Micro*"}
Get-ChildItem -Path ~ -file -Recurse| Where-Object {$_.LastWriteTime -ge (Get-Date).AddDays(-7)}
Get-Process -Name 'P*', 'b*'
Get-Process | Sort-Object -Property CPU |Select-Object -First 10 |Measure-Object -Property CPU
Get-Process | Where-Object {$_.Name -notlike 'W*'} |Sort-Object -Property CPU |Select-Object -First 10 |Measure-Object -Property CPU
Get-Process -Name 'svchost'

#Chapter 13
#Windows Remote Management (WinRM) is Mircosoft's implementation of the WS-Management Protocol 
Enter-PSSession -ComputerName Server22-01

Exit-PSSession

#Possible to use SSH (secure shell) as opposed to WinRM for connection negotation and data transport
#SSH needs to be on the local machine and the remote system needs to have PowerShell SSH installed
Enter-PSSession -HostName Server22-01

Invoke-command -ComputerName Server22-01 -ScriptBlock {
    Get-Service | where-object status -eq stopped
}

$commands = {
    Get-Service | where-object status -eq stopped
}

Invoke-command -ComputerName Server22-01 -ScriptBlock $commands

$commands = {Get-Process | Sort-Object -Property VirtualMemorySize -Descending | Select-Object -First 3}
Invoke-command -ComputerName Server22-01 -ScriptBlock $commands

New-Item -Path ~ -Name computers.txt -ItemType File
Add-Content -Path ~\computers.txt -Value Server22-01
Add-Content -Path ~\computers.txt -Value win11-client
Get-Content -Path ~\computers.txt

Invoke-command -ComputerName (Get-Content -Path ~\computers.txt) -ScriptBlock $commands

$commands = {$PSVersionTable}
Invoke-command -ComputerName (Get-Content -Path ~\computers.txt) -ScriptBlock $commands

