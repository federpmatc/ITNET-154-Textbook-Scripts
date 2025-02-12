#Chapter 7 - Adding Commands

#A PowerShell profile is a script that runs when PowerShell starts
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  #Locally created scripts will run

#https://www.howtogeek.com/50236/customizing-your-powershell-profile/
#There are multiple profiles

$profile
$profile | Get-Member
$profile | Select-Object *

$PROFILE.CurrentUserCurrentHost #Current User Current Host  (the host can be console or ISE)
$PROFILE.AllUsersCurrentHost #All users Current Host
$PROFILE.CurrentUserAllHosts 
$PROFILE.AllUsersAllHosts

#the $profile variable shows the one for the current user on the current host
$PROFILE.AllUsersAllHosts
Test-Path $PROFILE.AllUsersAllHosts

New-Item -path $PROFILE.AllUsersAllHosts -type file -Force

Add-Content -Path $PROFILE.AllUsersAllHosts '$Shell = $Host.UI.RawUI'
Add-Content -Path $PROFILE.AllUsersAllHosts '$Shell.WindowTitle="Pat Feder - PowerShell"'
Add-Content -Path $PROFILE.AllUsersAllHosts '$Shell = $Host.UI.RawUI'   #$Host is a variable that exposes PS environment
Add-Content -Path $PROFILE.AllUsersAllHosts '$shell.BackgroundColor = "black"'
Add-Content -Path $PROFILE.AllUsersAllHosts '$shell.ForegroundColor = "green"'
Add-Content -Path $PROFILE.AllUsersAllHosts '$colors = $host.PrivateData'
Add-Content -Path $PROFILE.AllUsersAllHosts '$colors.ErrorForegroundColor = "white"'
Add-Content -Path $PROFILE.AllUsersAllHosts '$colors.ErrorBackgroundColor = "red"'
Add-Content -Path $PROFILE.AllUsersAllHosts 'New-Alias -Name NP -Value notepad.exe'
Add-Content -Value "function h50 { Get-History -Count 50 }" -Path $PROFILE.AllUsersAllHosts
Add-Content -Value "function h10 { Get-History -Count 10 }" -Path $PROFILE.AllUsersAllHosts

Get-Content $PROFILE.AllUsersAllHosts

Remove-Item $profile.AllUsersAllHosts

#Chapter 7 - Adding Commands

#modules are a way to extend PowerShell
Get-ChildItem env:

Get-ChildItem Env:\PSModulePath #PowerShell automatically looks for modules here
$env:PSModulePath -split ';'    #Split is a PowewrShell operator that splits strings

Get-Module
Get-Module -ListAvailable

#modules are a way to extend PowerShell
Get-ChildItem env:
Get-ChildItem Env:\PSModulePath #PowerShell automatically looks for modules here
$env:PSModulePath -split ';'    #Split is a PowewrShell operator that splits strings

Get-Module
Get-Module -ListAvailable

#PowerShellGet is a module for locating and installing scripts, modules,etc.
Get-Command -Module PowerShellGet

Get-PSRepository    #Registered package repositories containing scripts, modules, etc
#Use the cmdlets in the PowerShellGet module to install packages from the PowerShell Gallery

Find-Module *wordle*
Save-Module PSWordle -Path C:\temp #we could inspect the module first
#The saved module can then be copied into the appropriate $env:PSModulePath 

Install-Module -Name PSWordle  
Get-Command -Module PSWordle

Find-Module *ntfs*    #locate modules in our PS Repository
Save-Module -Name NTFSSecurity -Path C:\temp #Save the module to a location

Install-Module NTFSSecurity #install modules (we could also specify a local path)
Get-InstalledModule

Get-Command -Module NTFSSecurity #Checkout the commands

New-Item -Path C:\Share -Type Directory
Get-NTFSAccess -path C:\Share
Get-Item C:\Share | Get-NTFSAccess
Get-Item C:\Share | Disable-NTFSAccessInheritance
Get-Item C:\Share | enable-NTFSAccessInheritance
Get-Item C:\Share | Get-NTFSAccess -ExcludeInherited | Export-Csv permissions.csv


