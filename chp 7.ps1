Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  #Locally created scripts will run

#https://www.howtogeek.com/50236/customizing-your-powershell-profile/
#There are multiple profiles
$profile
$profile | select *

$PROFILE.CurrentUserCurrentHost #Current User Current Host  (console or ISE)
$PROFILE.AllUsersCurrentHost #All users Current Host
$PROFILE.CurrentUserAllHosts 
$PROFILE.AllUsersAllHosts

#the $profile variable shows the one for the current user on the current host
$profile
Test-Path $profile

#The best one to use
New-Item -path $profile -type file –force
Add-Content -Path $profile '$Shell = $Host.UI.RawUI'
Add-Content -Path $profile '$Shell.WindowTitle="Pat Feder - PowerShell"'
Add-Content -Value "function h50 { Get-History -Count 50 }" -Path $profile
Add-Content -Value "function h10 { Get-History -Count 10 }" -Path $profile

notepad $profile

#add the following lines to the script
new-item alias:np -value notepad.exe
$Shell = $Host.UI.RawUI   #$Host is a variable that exposes

#PowerShell provides a built-in variable for accessing details about the PowerShell environment (Get-Host object.) 
$shell.BackgroundColor = "black"
$shell.ForegroundColor = "green"
$colors = $host.PrivateData
$colors.ErrorForegroundColor = "white"
$colors.ErrorBackgroundColor = "red"
$Shell.WindowTitle="ITNET-159"

Remove-Item $profile

#modules are a way to extend PowerShell
Get-ChildItem env:
Get-ChildItem Env:\PSModulePath #PowerShell automatically looks for modules here
$env:PSModulePath -split ';'

Get-Module
Get-Module -ListAvailable

#Getting modules from the internet
#http://powershellgallery.com
Get-PSRepository

Find-Module *ntfs* #From PS Repository
install-module NTFSSecurity #Download & install module

GCM -Module NTFSSecurity #Checkout the commands
Import-Module NTFSSecurity #Load the module

Get-InstalledModule
Get-Module
Get-Module -ListAvailable