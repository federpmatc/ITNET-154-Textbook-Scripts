<#
.SYNOPSIS
Get-PhysicalAdapters.ps1 retrieves network adapter information
.DESCRIPTION
Get-PhysicalAdapters.ps1 uses CIM to retrieves NIC info 
.PARAMETER computername
The computer name
.EXAMPLE
Get-PhysicalAdapters.ps1 -ComputerName Server22-02
#>
[CmdletBinding()]
<#The Cmdlet Binding directive adds new features to our script
we can use decorators to help manage our parameters
we can use write-verbose within the script
#>
param (
[Parameter(Mandatory=$True,  HelpMessage="Enter a computer name!!!")] [Alias('hostname')] [string[]]$computername

)
Write-Verbose "Connecting to $computername"

Get-CimInstance win32_networkadapter -ComputerName localhost | Where-Object { $_.PhysicalAdapter } | 
Select-Object MACAddress,AdapterType,DeviceID,Name,Speed

Write-host "All done!!!!!"