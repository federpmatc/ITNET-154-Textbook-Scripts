#Get-Adapter Info
Get-CimInstance win32_networkadapter -ComputerName localhost | where { $_.PhysicalAdapter } | 
Select-Object MACAddress,AdapterType,DeviceID,Name,Speed

