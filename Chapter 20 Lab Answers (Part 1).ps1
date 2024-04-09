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
#[cmdletbinding()]   #Must be first line after comment based helped, adds advanced features
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

## 
<# Notes
1.)  We added [cmdletbinding()]
This adds several additional features.  Not needed for this example.  Book doesn't cover this.
2.) Making parameters mandatory, creating aliases and the parameter is a string
+ [Parameter(Mandatory = $true)] - this decorator will prompt user for variable value
+ [HelpMessage="Enter a computername to query")] - provides a user prompt
+ [Alias()] - allows for parameter alias
+ Supports -Verbose switch.  Recall that the PowerShell supports various output streams.
The Information stream is intended for messages to understand what a script is doing
The Verbose stream is intended for troubleshooting.  Output is controlled with $VerbosePreference variable.
Default is $VerbosePreference = 'SilentlyContinue'.  Output is enable with 'Continue'
#>
