#____________________________________________________________
# https://www.techthoughts.info/powershell-remoting/
#____________________________________________________________

#region WinRM Links

#Running Remote Commands
#https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands?view=powershell-6

#Windows Remote Management
#https://docs.microsoft.com/en-us/windows/win32/winrm/portal
#Windows Remote Management (WinRM) is a Microsoft tool that allows you to manage and monitor remote computers. 
#It's built on the WS-Management protocol, which enables different operating systems and hardware to communicate with each other.


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

get-command Restart-Computer | Select-Object Parameters 
Get-Command | Where-Object { $_.parameters.keys -contains "ComputerName" -and $_.parameters.keys -notcontains "Session" }
Get-command -parametername ComputerName #this also returns commands that allow you to enter a remote session with 'ComputerName'
# Per PowerShell documentation you can find a list of cmdlets that support ComputerName with the following:
#In Windows Powershell we see more commands b/c DCOM protocol was used 
#For remoting on Windows with PowerShell we rely on WSMAn protocol and InvokeCommand
#WSMan protocol is implemented with the WinRM service

# this will prompt you to enter your access credentials. the creds will be securely stored in the variable
#admin P@ssw0rd or could specify a domain name ITNET\Admin (or Admin@itnet.pri and password)
$creds = Get-Credential

$RemoteDevice = "Server22-02"
# restart a single computer
Restart-Computer -ComputerName $RemoteDevice -Credential $creds -force

$RemoteDevice = "Win11-Client"
# restart several computers
Restart-Computer -ComputerName $RemoteDevice -Credential $creds -force

# restart an entire list of computers
New-Item -Type File -Path ~\listOfServers.txt
Add-Content -Path ~\listOfServers.txt -Value Win11-Client
Add-Content -Path ~\listOfServers.txt -Value Server22-02

$devices = Get-Content -Path ~\listOfServers.txt
Restart-Computer -ComputerName $devices -Credential $Creds -Force

#endregion

#region WinRM

#verify that WinRM is setup and configured locally
Test-WSMan

# basic WinRM configuration with default settings
Enable-PSRemoting


# check winrm settings
winrm get winrm/config/client      #Client is used to connect to other devices
winrm get winrm/config/service     #Service is what the device uses when being connected to


#verify that WinRM is setup and responding on a remote device
#you must specify the authentication type when testing a remote device.
#if you are unsure about the authentication, set it to Negotiate
$credential = Get-Credential
$RemoteDeviceName = "Server22-02"

Test-WSMan $RemoteDeviceName -Credential $credential

#verify local device is listening on WinRM port
Get-NetTCPConnection -LocalPort 5985   #(http uses port 5985, which is used internal network) 

$RemoteDeviceName = "Win11-Client"
#verify a remote device is listening on WinRM port
Test-NetConnection -Computername $RemoteDeviceName -Port 5985

#establish an interactive remote session
$credential = Get-Credential
Enter-PSSession -ComputerName $RemoteDeviceName -Credential $credential

#basic session opened to remote device
$session = New-PSSession -ComputerName $RemoteDeviceName -Credential $credential

#establish sessions to multiple devices
$credential = Get-Credential
$multiSession = New-PSSession -ComputerName Server22-02, Win11-Client -Credential $credential

Get-PSSession | Remove-PSSession #Close all sessions
Get-PSSession

#region Invoke-Command examples

#get the number of CPUs for each remote device
#When $( ) is used, PowerShell evaluates the expression or command inside the parentheses and substitutes the result 
#into the string.
Invoke-Command -Session $multiSession -ScriptBlock { 
   "$((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) $env:computername"    
}
#OR
Invoke-Command -Session $multiSession -ScriptBlock { 
   $result = "$((Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors) $env:computername"
   return $result
}

#get the amount of free space on the C: drive for each remote device
Invoke-Command -Session $Multisession -ScriptBlock {
    $driveData = Get-PSDrive C | Select-Object Used, Free
    $total = $driveData.Used + $driveData.Free
    $calc = [Math]::Round($driveData.Free / $total, 2)
    $perFree = $calc * 100
    return "$env:COMPUTERNAME $perFree% free on C: drive"
}

#get the number of CPUs for each remote device
Invoke-Command -Session $sessions -ScriptBlock { (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors }

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

#region advanced WinRM

#declare servers we will connect to remotely
$servers = 'Server1', 'Server2', 'Server3', 'Server4'
#capture credentials used for remote access
$creds = Get-Credential

#declare array to hold remote command results
$remoteResults = @()

#declare a splat for our Invoke-Command parameters
#Hashtables consist of Key/Value Pairs
#Splatting involves using a hashtable to hold command paramter names and values
$invokeSplat = @{
    ComputerName  = "Server22-02","Win11-Client"
    Credential    = $creds
    ErrorVariable = 'connectErrors'
    ErrorAction   = 'SilentlyContinue'
}

$invokeSplat 

#execute remote command with splatted parameters.
#store results in variable
$remoteResults = Invoke-Command @invokeSplat -ScriptBlock {
    #declare a custom object to store result in and return
    $obj = [PSCustomObject]@{
        Name      = $env:COMPUTERNAME
        CPUs      = "-------"
        Memory    = "-------"
        FreeSpace = "-------"
    }
    #retrieve the CPU / Memory / Hard Drive information
    $obj.CPUs = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
    $obj.Memory = Get-CimInstance Win32_OperatingSystem `
    | Measure-Object -Property TotalVisibleMemorySize -Sum `
    | ForEach-Object { [Math]::Round($_.sum / 1024 / 1024) }
    $driveData = Get-PSDrive C | Select-Object Used, Free
    $total = $driveData.Used + $driveData.Free
    $calc = [Math]::Round($driveData.Free / $total, 2)
    $obj.FreeSpace = $calc * 100
    return $obj
}

