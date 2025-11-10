Get-PSDrive | Where-Object{($_.Free -gt 1) -and ($_.Name.Length -eq 1)} | 
ForEach-Object `
{$Count = 0; Write-Host "";} `
{ $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
{Write-Host"";Write-Host "Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}

#I removed write-host (below) to just get string objects in the pipeline
$computername = "Server22-01","Win11-Client"
Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-PSDrive | Where-Object{$_.Free -gt 1} | 
    ForEach-Object{$Count = 0; Write-Host "";} `
    { "$env:COMPUTERNAME $($_.Name): Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
    
    "Total Free Space $([int]($Count / 1gb))GB"
}

#Paramterized Script
param (
    $computername = "Server22-01",
    $name = "Pat"
)
"....................$(Get-Date) Hey $name Checking the disk space on $computername  ..............................."
Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-PSDrive | ?{$_.Free -gt 1} | 
    %{$Count = 0; Write-Host "";} `
    { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
    
    "$env:COMPUTERNAME Total Free Space $([int]($Count / 1gb))GB"
}



<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or
more computers.
.DESCRIPTION
Get-DiskInventory uses Get-PSDrive
.PARAMETER computername
The computer name, or names, to query. Default: Server2019-1
.PARAMETER name
Just display additional text to include in the output
Using parameter
.EXAMPLE
Get-DiskInventory -computername SERVER22-01 -name Pat
.EXAMPLE
Get-DiskInventory Win11-Client Pat
This is cool
#>

<#
This is a multi-line comment
#>
param (
    [string[]] $computername = @("Server22-01","Win11-Client"),   #array of strings
    [string] $name = "Pat"
)

#"....................$(Get-Date) Hey $name Checking the disk space on $computername  ..............................."
Invoke-Command -ComputerName $computername -ScriptBlock {
    $count = 0GB
    write-output ""
    Get-PSDrive | Where-Object{$_.Free -gt 1} | 
    ForEach-Object {
        "$env:COMPUTERNAME $($_.Name): Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;
        #"$env:COMPUTERNAME $($_.Name): Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;
    }
    "$env:COMPUTERNAME Total Free Space $([int]($Count / 1gb))GB"
}
