<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or
more computers.
.DESCRIPTION
Get-DiskInventory uses CIM to retrieve the Win32_LogicalDisk
instances from one or more computers. It displays each disk's
drive let ter, free space, total size, and percentage of free
space.
.PARAMETER computername
The computer name
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation
for values. 3 is a fixed disk, and is the default.
.EXAMPLE
Get-DiskInventory -ComputerName Server22-02 -drivetype 3
.EXAMPLE
Get-DiskInventory -ComputerName Win11-Client -drivetype 3
#>
param (
[string[]]$computername,
[int]$drivetype
)

Get-CimInstance -class Win32_LogicalDisk  -ComputerName $computername -filter "drivetype=$drivetype" |
 Sort-Object -property DeviceID |
 Select-Object -property DeviceID,@{label='FreeSpace(GB)';expression={$_.FreeSpace / 1GB}},
 @{label='Size(GB)';expression={$_.Size / 1GB}},
 @{label='%Free';expression={$_.FreeSpace / $_.Size * 100}},
 @{label='System Name';expression={$_.SystemName}}
 
