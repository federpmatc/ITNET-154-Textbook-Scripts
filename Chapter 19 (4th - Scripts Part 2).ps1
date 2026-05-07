$Count = 0; Write-Host "";
Get-PSDrive | Where-Object{($_.Free -gt 1) -and ($_.Name.Length -eq 1)} | 
ForEach-Object { 
        $used = $_.Used/1gb
        $free = $_.free/1gb
        $total = $used + $free
        $DiskName = $_.name
        write-host ("$DiskName : Used {0:N2} Free: {1:N2} Total: {2:N2}" -f $used, $free, $total) -BackgroundColor Yellow
        $Count = $Count + $free
}
Write-Host ""
Write-Host ("Total Free Space {0:N0}" -f $Count) -backgroundcolor magenta

#I removed write-host (below) to just get string objects in the pipeline
$computername = "Server22-01","Win11-Client"
$Count = 0GB
Write-Output ""
Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-PSDrive | Where-Object{$_.Free -gt 1} | 
    ForEach-Object { 
        $used = $_.Used/1gb
        $free = $_.free/1gb
        $total = $used + $free
        $DiskName = $_.name
        write-host ("$DiskName : Used {0:N2} Free: {1:N2} Total: {2:N2}" -f $used, $free, $total) -BackgroundColor Yellow
        $Count = $Count + $free
}
Write-Host ""
Write-Host ("Total Free Space {0:N0}" -f $Count) -backgroundcolor magenta

#Paramterized Script
param (
    $computername = "Server22-01",
    $name = "Pat"
)
"....................$(Get-Date) Hey $name Checking the disk space on $computername  ..............................."
Invoke-Command -ComputerName $computername -ScriptBlock {
    $Count = 0GB
    Write-Output ""
    Get-PSDrive | Where-Object{$_.Free -gt 1} | 
    ForEach-Object { 
        $used = $_.Used/1gb
        $free = $_.free/1gb
        $total = $used + $free
        $DiskName = $_.name
        write-host ("$DiskName : Used {0:N2} Free: {1:N2} Total: {2:N2}" -f $used, $free, $total) -BackgroundColor Yellow
        $Count = $Count + $free
    }
    
    write-host ("### $env:COMPUTERNAME Total Free Space {0:N0}GB ###" -f $count) -BackgroundColor Yellow
    write-host ("`n") -BackgroundColor Black
}

#Documenting our script with help that mimics PowerShell's help files

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
        $used = $_.Used/1gb
        $free = $_.free/1gb
        $total = $used + $free
        $DiskName = $_.name
        write-host ("$DiskName : Used {0:N2} Free: {1:N2} Total: {2:N2}" -f $used, $free, $total) -BackgroundColor Yellow
        $Count = $Count + $free
    }
    
    write-host ("### $env:COMPUTERNAME Total Free Space {0:N0}GB ###" -f $count) -BackgroundColor Yellow
    write-host ("`n") -BackgroundColor Black
}
}


