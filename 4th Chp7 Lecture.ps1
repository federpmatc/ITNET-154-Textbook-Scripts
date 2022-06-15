#Chapter 7 - Adding Commands


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

Find-Module *ntfs*    #locate modules in our PS Repository
Install-Module NTFSSecurity #install modules

Get-Command -Module NTFSSecurity #Checkout the commands

Get-InstalledModule
