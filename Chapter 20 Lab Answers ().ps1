<#
.Synopsis
Get physical network adapters
.Description
Display all physical adapters from the Win32_NetworkAdapter class.
.Parameter Computername
The name of the computer to check.
.Example
PS C:\> c:\scripts\Get-PhysicalAdapters -computer SERVER01
#>
[cmdletbinding()]   #
Param (
[Parameter(Mandatory=$True, HelpMessage="Enter a computername to query")]
[alias('host')]
[string]$Computername
)
Write-Verbose "Getting physical network adapters from $computername"
Get-CimInstance -class win32_networkadapter –computername $computername |
 Where-Object { $_.PhysicalAdapter } |
 Select-Object MACAddress,AdapterType,DeviceID,Name,Speed
Write-Verbose "Script finished."
