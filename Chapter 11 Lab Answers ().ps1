#Chapter 11 - 4th edition

gsv | ft #columns & rows
gsv | ft -Wrap 
gsv | format-table -Property status, name

# new set of column headers each time the specified property value changes
gsv | format-table -GroupBy status

gsv| fl
gsv | fw name -Column 6

#Creating custom value
gps | Select-Object -First 5

gps | Select-Object -First 5 | select name, @{name='VM(MB)';expression={$_.VM/1MB -as [int]}}

gps | Select-Object -First 5 | select name, @{name='VM(MB)';expression={$_.VM/1MB -as [int]}},`
@{name='ProcessID';expression={$_.Id}}

gps | Select-Object -First 5 | select name, @{name='VM(MB)';expression={$_.VM/1MB -as [int]}},`
@{name='ProcessID';expression={$_.Id}} | Out-GridView


<#Display a table of processes that includes only the process names, IDs, and
whether they’re responding to Windows (the Responding property has that
information). Have the table take up as little horizontal room as possible, but
don’t allow any information to be truncated.#>

Get-Process | Format-Table Name,ID,Responding -Wrap

Get-Process | Where-Object Responding -eq $true| Format-Table Name,ID,Responding -Wrap

<#2 Display a table of processes that includes the process names and IDs. Also
include columns for virtual and physical memory usage, expressing those values
in megabytes (MB).
#>
Get-Process | Format-Table Name,ID,
@{l='VirtualMB';e={[int] ($_.vm/1MB)}},
@{l='PhysicalMB';e={[int]($_.workingset/1MB)}}

<#
3 Use Get-Module to get a list of loaded modules. Format the output as a table
that includes, in this order, the module name and the version. The column
headers must be ModuleName and ModuleVersion.
#>
Get-Module| Format-Table @{l='ModuleName';e={$_.Name }},
@{l='ModuleVersion';e={$_.Version}}



<#5 Display a four-column-wide list of all directories in the home directory.
#>
gci ~ | fw -propery name -Column 4

<#6 Create a formatted list of all .dll files in $pshome, displaying the name, version
information, and file size. PowerShell uses the Length property, but to make it
clearer, your output should show Size. 
$PSHOME automatic variable contains the full file path to the installation directory of the currently running PowerShell session
#>
gci $pshome/*.dll | select-object -First 3 |
Format-List Name,VersionInfo,@{Name="Size";Expression={$_.length}}

gci $pshome/*.dll |  select-object -First 3 |
FT Name,@{Name="Size";Expression={$_.length}},VersionInfo 

gci $pshome/*.dll |
Select-Object Name,VersionInfo,@{Name="Size";Expression={$_.length}} | Out-GridView



