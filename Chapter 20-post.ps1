<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or
more computers.
.DESCRIPTION
Get-DiskInventory uses CIM to retrieve the Win32_LogicalDisk
instances from one or more computers. It displays each disk's
drive letter, free space, total size, and percentage of free
space.
.PARAMETER computername
The computer name
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation
for values. 3 is a fixed disk, and is the default.
.EXAMPLE
Get-DiskInventory -ComputerName Server22-02 -drivetype 3
#>
[CmdletBinding()]
<#The Cmdlet Binding directive adds new features to our script
we can use decorators to help manage our parameters
we can use write-verbose within the script
#>
param (
[Parameter(Mandatory=$True,  HelpMessage="Enter a computer name!!!")] [Alias('hostname')] [string[]]$computername,

[ValidateSet(2,3)] [int]$drivetype = 3
)
Write-Verbose "Connecting to $computername"
Write-Verbose "Looking for drive type $drivetype"

Get-CimInstance -class Win32_LogicalDisk -ComputerName $computername `
 -filter "drivetype=$drivetype" |
 Sort-Object -property DeviceID |
 Select-Object -property DeviceID,
 @{label='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
 @{label='Size(GB)';expression={$_.Size / 1GB -as [int]}},
 @{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}

Write-host "All done!!!!!"
