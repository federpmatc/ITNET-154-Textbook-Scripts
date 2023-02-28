#____________________________________________________________
# https://www.techthoughts.info/powershell-remoting/
#____________________________________________________________

#region WinRM Links

#Running Remote Commands
#https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands?view=powershell-6

#Windows Remote Management
#https://docs.microsoft.com/en-us/windows/win32/winrm/portal

#Installation and Configuration for Windows Remote Management
#https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management

#Making the second hop in PowerShell Remoting
#https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ps-remoting-second-hop?view=powershell-6

#PowerShell remoting over SSH
#https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core?view=powershell-6

#How to configure WinRM for HTTPS manually
#https://www.visualstudiogeeks.com/devops/how-to-configure-winrm-for-https-manually

#endregion

#region ComputerName

# Per PowerShell documentation you can find a list of cmdlets that support ComputerName with the following:
#In Windows Powershell we see more commands b/c DCOM protocol was used
#PowerShell we rely on WinRM protocol and InvokeCommand
Get-Command -ParameterName ComputerName

# this will prompt you to enter your access credentials. the creds will be securely stored in the variable
$creds = Get-Credential
#password is secure and can be sent over the wire

# restart a single computer
Restart-Computer -ComputerName W10-Client -Credential $creds -Force

# restart several computers
Restart-Computer -ComputerName W10-Client, Server2019-2 -Credential $creds

# restart an entire list of computers
$devices = Get-Content -Path C:\listOfServers.txt
Restart-Computer -ComputerName $devices -Credential $Creds -Force

#endregion

#region WinRM

#verify that WinRM is setup and configured locally
Test-WSMan

# basic WinRM configuration with default settings
winrm quickconfig

# check winrm settings
winrm get winrm/config/client
winrm get winrm/config/service #admin priv.

#verify that WinRM is setup and responding on a remote device
#you must specify the authentication type when testing a remote device.
#if you are unsure about the authentication, set it to Negotiate
$credential = Get-Credential
Test-WSMan  W10-Client 

#verify local device is listening on WinRM port
Get-NetTCPConnection -LocalPort 5985

#verify a remote device is listening on WinRM port
Test-NetConnection -Computername 192.168.222.101 -Port 5985

#establish an interactive remote session
$credential = Get-Credential
Enter-PSSession -ComputerName W10-Client -Credential $credential

#basic session opened to remote device
$session = New-PSSession -ComputerName W10-Client -Credential itnet\admin

#establish sessions to multiple devices
$credential = Get-Credential
$multiSession = New-PSSession -ComputerName W10-Client,Server2019-2 -Credential $credential

#establish session to an entire list of devices
$devices = Get-Content -Path C:\listOfServers.txt
$credential = Get-Credential
$multiSession = New-PSSession -ComputerName $devices -Credential $credential

#endRegion

#region Invoke-Command examples
Invoke-Command -Session $multiSession -ScriptBlock { gsv |Select-Object -First 2 }

#get the number of CPUs for each remote device
Invoke-Command -Session $session -ScriptBlock { (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors }
Invoke-Command -Session $multiSession -ScriptBlock { (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors }

#get the amount of RAM for each remote device
Invoke-Command -Session $session -ScriptBlock { Get-CimInstance Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | ForEach-Object { $_.sum / 1MB } }
Invoke-Command -Session $multiSession -ScriptBlock { Get-CimInstance Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | ForEach-Object { [int] ($_.sum / 1024 / 1024) } }

#get the amount of free space on the C: drive for each remote device
Invoke-Command -Session $multiSession -ScriptBlock {
    $driveData = Get-PSDrive C | Select-Object Used, Free
    $total = $driveData.Used + $driveData.Free
    $calc = [Math]::Round($driveData.Free / $total, 2)
    $perFree = $calc * 100
    $msg = "$env:COMPUTERNAME has $perfree %free space"
    return $msg
}

#get the number of CPUs for each remote device
Invoke-Command -Session $multiSession -ScriptBlock { "$env:COMPUTERNAME $((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors)" 
}

#get the amount of RAM for each remote device
Invoke-Command -Session $sessions -ScriptBlock { Get-CimInstance Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | ForEach-Object { [Math]::Round($_.sum / 1024 / 1024) } }

#get the amount of free space on the C: drive for each remote device
Invoke-Command -Session $sessions -ScriptBlock {
    $driveData = Get-PSDrive C | Select-Object Used, Free
    $total = $driveData.Used + $driveData.Free
    $calc = [Math]::Round($driveData.Free / $total, 2)
    $perFree = $calc * 100
    return $perFree
}