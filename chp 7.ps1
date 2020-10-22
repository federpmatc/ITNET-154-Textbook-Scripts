#Chapter 7 - Adding Commands

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  #Locally created scripts will run

#profiles
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-5.1

#https://www.howtogeek.com/50236/customizing-your-powershell-profile/
#There are multiple profiles

#A PowerShell profile is a script that runs when PowerShell starts. 
#You can use the profile as a logon script to customize the environment. 

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
New-Item -path $profile -type file –force
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

#We need to install Nuget, which is a package provider used by the PS Repository
#Refer to https://docs.microsoft.com/en-us/nuget/what-is-nuget for more info on NuGet

Get-PackageProvider -ListAvailable #get list of all package providers that are available on the local computer.
Find-PackageProvider -Name "Nuget" -AllVersions
#We need to install NuGet
#The Microsoft-supported mechanism for sharing code is NuGet, which defines how packages for .NET are created, hosted, and consumed

[Net.ServicePointManager]::SecurityProtocol
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
[Net.ServicePointManager]::SecurityProtocol

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Get-PackageProvider #Get all currently loaded package providers

#Getting modules from the internet
#http://powershellgallery.com (could use find-module ntfs*)
Install-Module -Name NTFSSecurity

Get-Command -Module NTFSSecurity #Checkout the commands
Import-Module NTFSSecurity #Load the module

Get-InstalledModule
Get-Module

Get-Module -ListAvailable 
