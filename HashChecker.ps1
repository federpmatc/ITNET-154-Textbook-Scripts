Write-Host “This script grabs the SHA256, SHA1, or MD5 hash of the most recent file in the Downloads folder and compares it to the checksum input below.“
#SHA-256 generates a 256 bit hash (64 Hex characters)
#SHA-1 generates 160 bit hash (40 hex characters)
#MD-5 generates 128 bit hash (32 hex characters)

#Environment variables contain settings used by your OS
Get-ChildItem env:

#Tilde (~), when used at the beginning of path, refers to home directory (profile)
Get-Item  -Path ~
Get-Item  -path $env:userprofile

Get-ChildItem ~\Downloads

$DownloadedFile = (Get-ChildItem ~\Downloads\ | Sort-Object LastWriteTime | Select-Object -last 1).FullName
Write-Host "The download source is: $DownloadedFile"

$Checksum = Read-Host -Prompt “Please enter the known-good checksum from the download source”

    if ($Checksum.length -eq 32){
        $Hash = “MD5”
    }
    elseif ($Checksum.length -eq 40) {
        $Hash = “SHA1”
    }
    elseif ($Checksum.length -eq 64) {
        $Hash = “SHA256”
    }
    else {
        #Throw - Terminates Execution: Throw halts the current execution flow. 
        #No further statements will be processed after a throw statement.
        Throw Read-Host “The only supported hash algorithms at this time are SHA256, SHA1, and MD5. Press Enter to exit”
    }

$DownloadedFileHash = (Get-FileHash -Path $DownloadedFile -Algorithm $Hash).Hash 

    if ($DownloadedFileHash -eq $Checksum) {
        Write-Host “The checksum and file hash match“ -ForegroundColor Green
    }
    else {
        Write-Host “The checksum and file name DO NOT match“ -ForegroundColor Red
    }

Write-Host “    File Path: $DownloadedFile"
Write-Host "    File Hash Algortithm $Hash"
Write-Host “    File Hash: $DownloadedFileHash"
Write-Host “    Checksum:  $Checksum"
Write-Host “”
Read-Host -Prompt “Press Enter to exit”
