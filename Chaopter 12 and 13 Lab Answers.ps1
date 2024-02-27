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

Enter-PSSession -ComputerName Server2019-1
Exit-PSSession

Invoke-Command -ComputerName Server2019-1 -ScriptBlock {Get-Service | Where-Object {$_.status -eq "Stopped"}}

Invoke-Command -ComputerName Server2019-1, W10-Client -ScriptBlock {get-process | 
    sort-object -property VM | Select-Object -First 3}

New-Item -ItemType File -Path ~\computers.txt
Add-Content -Path ~\computers.txt -Value "Server2019-1", "W10-Client"
Get-Content -Path ~\Computers.txt
Invoke-Command -ComputerName (Get-Content ~\computers.txt) -ScriptBlock {get-process | 
    sort-object -property VM | Select-Object -First 3}

Invoke-Command -ComputerName Server2019-1, W10-Client -ScriptBlock {$PSVersionTable.PSVersion}
