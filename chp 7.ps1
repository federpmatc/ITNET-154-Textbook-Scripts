#Chapter 7 - Adding Commands

#A PowerShell profile is a script that runs when PowerShell starts
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  #Locally created scripts will run

#https://www.howtogeek.com/50236/customizing-your-powershell-profile/
#There are multiple profiles

$profile
$profile | select *

$PROFILE.CurrentUserCurrentHost #Current User Current Host  (the host can be console or ISE)
$PROFILE.AllUsersCurrentHost #All users Current Host
$PROFILE.CurrentUserAllHosts 
$PROFILE.AllUsersAllHosts

#the $profile variable shows the one for the current user on the current host
$profile
Test-Path $profile

#The best one to use
New-Item -path $profile -type file -Force
Add-Content -Path $profile '$Shell = $Host.UI.RawUI'
Add-Content -Path $profile '$Shell.WindowTitle="Pat Feder - PowerShell"'
Add-Content -Value "function h50 { Get-History -Count 50 }" -Path $profile
Add-Content -Value "function h10 { Get-History -Count 10 }" -Path $profile

notepad $profile

#add the following lines to the script
New-Alias -Name NP -Value notepad.exe
$Shell = $Host.UI.RawUI   #$Host is a variable that exposes PS environment

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
$env:PSModulePath -split ';'    #Split is a PowewrShell operator that splits strings

Get-Module
Get-Module -ListAvailable

#https://gallery.technet.microsoft.com/scriptcenter/How-to-switch-UAC-level-0ac3ea11


Get-Package #installed s/w packages
#Package Management - https://www.sconstantinou.com/powershell-packagemanagement/
#Regardless of the installation technology underneath, users can use these common cmdlets to install/uninstall 
#packages, add/remove/query package repositories, and query a system for the software installed.

Get-PackageProvider #providers (technologies) used to install our software packages

#PowerShellGet is a module for locating and installing scripts, modules,etc.
Get-Command -Module PowerShellGet

Get-PSRepository    #Registered package repositories containing scripts, modules, etc
#Use the cmdlets in the PowerShellGet module to install packages from the PowerShell Gallery

Find-Module *ntfs*    #locate modules in our PS Repository
Install-Module NTFSSecurity #install modules
#Nuget was installed, which is a package provider now used by the PS Repository
#The Microsoft-supported mechanism for sharing code is NuGet, which defines how packages for .NET are created, hosted, and consumed
#Refer to https://docs.microsoft.com/en-us/nuget/what-is-nuget

Get-Command -Module NTFSSecurity #Checkout the commands

Get-InstalledModule
