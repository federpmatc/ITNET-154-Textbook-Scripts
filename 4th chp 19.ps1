Get-PSDrive | ?{$_.Free -gt 1} | 
%{$Count = 0; Write-Host "";} `
{ $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
{Write-Host"";Write-Host "Total Free Space " ("{0:N2}" -f ($Count/1gb)) -backgroundcolor magenta}

#I removed write-host (below) to just get string objects in the pipeline
$computername = "Server2019-1","W10-Client"
Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-PSDrive | ?{$_.Free -gt 1} | 
    %{$Count = 0; Write-Host "";} `
    { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
    
    "$env:COMPUTERNAME Total Free Space $([int]($Count / 1gb))GB"
}

#Paramterized Script
param (
    $computername = "Server2019-1",
    $name = "Pat"
)
"....................$(Get-Date) Hey $name Checking the disk space on $computername  ..............................."
Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-PSDrive | ?{$_.Free -gt 1} | 
    %{$Count = 0; Write-Host "";} `
    { $_.Name + ": Used: " + "{0:N2}" -f ($_.Used/1gb) + " Free: " + "{0:N2}" -f ($_.free/1gb) + " Total: " + "{0:N2}" -f (($_.Used/1gb)+($_.Free/1gb)); $Count = $Count + $_.Free;}`
    
    "$env:COMPUTERNAME Total Free Space $([int]($Count / 1gb))GB"
}
