#PowerShell Execution Policies
#PowerShell's execution policy is a safety feature that controls the conditions under which PowerShell 
#loads configuration files and runs scripts. This feature helps prevent the execution of malicious scripts.

#RemoteSigned
<#
The default execution policy for Windows server computers.
Requires a digital signature on files that are downloaded from the internet which includes email and instant messaging programs.
#>

#Restricted
<#The default execution policy for Windows client computers.
Permits individual commands, but does not allow scripts.
#>

<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or
more computers.
.DESCRIPTION
Get-DiskInventory uses CIM to retrieve the Win32_LogicalDisk
instances from one or more computers. It displays each disk's
drive letter, free space, total size, and percentage of free
.PARAMETER computername
The computer name, or names, to query. Default: Localhost.
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation
for values. 3 is a fixed disk, and is the default.
.EXAMPLE
Get-DiskInventory -computername SRV02 -drivetype 3
#>
param (
$computername = 'localhost',
$drivetype = 3
)
Get-CimInstance -class Win32_LogicalDisk -computername $computername `
-filter "drivetype=$drivetype" |
Sort-Object -property DeviceID |
Format-Table -property DeviceID,
@{label='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
@{label='Size(GB';expression={$_.Size / 1GB -as [int]}},
@{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}
