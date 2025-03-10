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
#For remoting on Windows with PowerShell we rely on WSMAn protocol and InvokeCommand
#WSMan is implemented with the WinRM service

Get-Command -ParameterName ComputerName

# this will prompt you to enter your access credentials. the creds will be securely stored in the variable
$creds = Get-Credential
#admin or ITNET\Admin or Admin@itnet.pri
#password is secure and can be sent over the wire

# restart a single computer
Restart-Computer -ComputerName Win11-Client -Credential $creds -Confirm   #Disabling the WinRM service on client prevents this from working

# restart several computers
Restart-Computer -ComputerName Win11-Client, Server22-02 -Credential $creds -Confirm

# restart an entire list of computers
New-Item -Path ~\listOfServers.txt
Add-content -Path ~\listOfServers.txt "Win11-Client", "Server22-02"
Get-Content ~\listOfServers.txt
$devices = Get-Content -Path ~\listOfServers.txt
Restart-Computer -ComputerName $devices -Credential $Creds -Confirm

#endregion

#region WinRM

#verify that WinRM is setup and configured locally
#Recall that WinRM is Microsoft's implementation of WSMan protocl
Test-WSMan

# basic WinRM configuration with default settings
Enable-PSRemoting

# check winrm settings
winrm get winrm/config/client #return info on the client (used to access a service on remote system)
winrm get winrm/config/service #admin priv.

#verify that WinRM is setup and responding on a remote device
#you must specify the authentication type when testing a remote device.
#if you are unsure about the authentication, set it to Negotiate
$credential = Get-Credential
Test-WSMan  "Win11-Client"
Test-WSMan  "Server22-02"

#verify local device is listening on WinRM port
Get-NetTCPConnection -LocalPort 5985

#verify a remote device is listening on WinRM port
Test-NetConnection -Computername 192.168.222.101 -Port 5985
Test-NetConnection -Computername Win11-Client -Port 5985

#establish an interactive remote session
$credential = Get-Credential
Enter-PSSession -ComputerName Win11-Client -Credential $credential

#basic session opened to remote device
$session = New-PSSession -ComputerName Win11-Client -Credential itnet\admin
#session variable contains information about the active session we have with the remote machine

#establish sessions to multiple devices
$credential = Get-Credential
$multiSession = New-PSSession -ComputerName Win11-Client,Server22-02 -Credential $credential

#establish session to an entire list of devices
$devices = Get-Content -Path C:\listOfServers.txt
$credential = Get-Credential
$multiSession = New-PSSession -ComputerName $devices -Credential $credential

#endRegion

#region Invoke-Command examples
Invoke-Command -Session $multiSession -ScriptBlock { gsv |Select-Object -First 2 }
#the machines will all work in parallel, so first machine to responds get its info presented
#you may need to include machine name in script

#get the number of CPUs for each remote device
Invoke-Command -Session $session -ScriptBlock { (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors }
#you may need to include machine name in script

Invoke-Command -Session $multiSession -ScriptBlock { HOSTNAME.EXE
    (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors 
}
#you may need to include machine name in script
Invoke-Command -Session $multiSession -ScriptBlock { "$(HOSTNAME.EXE) has this many processors $((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) "
}

#OR
Invoke-Command -Session $multiSession -ScriptBlock { 
   $result = "$((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) $env:computername"
   return $result
}

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
#machine name in script

#get the number of CPUs for each remote device
Invoke-Command -Session $multiSession -ScriptBlock { "$env:COMPUTERNAME $((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors)" 
}

#get the amount of RAM for each remote device
Invoke-Command -Session $session -ScriptBlock { Get-CimInstance Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | ForEach-Object { [Math]::Round($_.sum / 1024 / 1024) } }

#get the amount of free space on the C: drive for each remote device
Invoke-Command -Session $session -ScriptBlock {
    $driveData = Get-PSDrive C | Select-Object Used, Free
    $total = $driveData.Used + $driveData.Free
    $calc = [Math]::Round($driveData.Free / $total, 2)
    $perFree = $calc * 100
    return $perFree
}
