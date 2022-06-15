Install-Module ????

Get-Command –module ????

Find-Module -Command Compress-Archive | Install-Module -Force

Import-Module Microsoft.PowerShell.Archive

1..10 #will create a collection of the numbers between 1 and 10. 

New-Item ~/TestFolder -ItemType Directory
1..10 | ForEach-Object {New-Item "~/TestFolder/$_.txt" -ItemType File -Value $_}

Compress-Archive ~/TestFolder/* -DestinationPath ~/TestFolder.zip

Expand-Archive ~/TestFolder.zip -DestinationPath ~/TestFolder2

$reference = Get-ChildItem ~/TestFolder| Select-Object -ExpandProperty name
$difference = Get-ChildItem ~/TestFolder3| Select-Object -ExpandProperty name
Compare-Object -ReferenceObject $reference -DifferenceObject $difference
