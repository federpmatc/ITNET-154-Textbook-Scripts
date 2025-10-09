#Q1
find-module *wordle*
Install-Module PSWordle
Get-InstalledModule


#Q2
Get-Command –module PSWordle


#Q3
get-command Compress-Archive
get-module  Microsoft.PowerShell.Archive #Gets module
find-module  Microsoft.PowerShell.Archive #Most likely same version, if not complete the command below
Install-Module  Microsoft.PowerShell.Archive -Force #installs module from PSGallery
Find-Module -Command Compress-Archive | Install-Module -Force #Another way to install the module


#Q4
import-module PSWordle
get-module


#Q5
1..10 #will create a collection of the numbers between 1 and 10.
New-Item ~/TestFolder -ItemType Directory #New folder
1..10 | ForEach-Object {New-Item "~/TestFolder/$_.txt" -ItemType File -Value $_} #Create 10 files


#Q6
Compress-Archive ~/TestFolder/* -DestinationPath ~/TestFolder.zip
Get-ChildItem ~


Expand-Archive ~/TestFolder.zip -DestinationPath ~/TestFolder2
Get-ChildItem ~
Get-ChildItem ~/TestFolder2


#Q7
New-Item -ItemType File -Name ExtraFile.txt -Path ~/TestFolder2 -Force


#Q8
$reference = Get-ChildItem ~/TestFolder | Select-Object -ExpandProperty name
$difference = Get-ChildItem ~/TestFolder2 | Select-Object -ExpandProperty name
Compare-Object -ReferenceObject $reference -DifferenceObject $difference

