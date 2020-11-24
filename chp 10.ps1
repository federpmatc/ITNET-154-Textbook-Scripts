#Formatting - Chapter 10
 
#PS has a process to determine output
#1.)"pre-defined rules" that control the output (based on the object type) - This includes column headers, column size, properties, etc.
Get-Process

#2.) Pre-defined default property set.  (If this doesn't exist, all properties will be displayed)
Get-WmiObject Win32_Operating System

#3.) 4 or fewer properties output goes to table.  5 or greater properties go to a list

#4.) If the formatting (above) is not predefined all properties are displayed

#Formatting Tables
Get-Service 
Get-Service | ft -AutoSize  #-Autosize will resize columns to remove unnecessary spaces (or increase column size as needed)
Get-Service | ft -Wrap
Get-Service | ft -Property name,status -AutoSize
Get-Service |select -First 2| ft -Property * #Not all properties can be displayed
Get-Service -Name win* | Sort-Object StartType | Format-Table -GroupBy StartType #New set of column headers when StartType changes
#Display a list of services that are grouped by running / or not running

Get-Service |select -First 2| Format-List -Property * #Display all properties

Get-Service | Format-Wide  -Column 5 #format wide displays a single property

Get-Service | Out-GridView -Title Services #you don't specify properties of the object to display

#Creating Custom Columns with hash tables (consist of key/value pairs)
gps | ft Name,
@{name='VM(MB)';expression={$_.VM/1GB -as [int] }}

