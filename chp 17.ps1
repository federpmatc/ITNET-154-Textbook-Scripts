#https://community.spiceworks.com/how_to/153255-windows-10-signing-a-powershell-script-with-a-self-signed-certificate
#Overview - https://sid-500.com/2017/10/26/how-to-digitally-sign-powershell-scripts/

Get-ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy AllSigned

New-Item -path "test.ps1"  -ItemType file -force
Add-Content -Path "test.ps1" -Value "Write-host 'Hello'"
notepad test.ps1

New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -Subject "CN=Local Code Signing" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature  -Type CodeSigningCert

certmgr /s my
#copy paste certificate from 

$cert = @(Get-ChildItem cert:\CurrentUser\My -CodeSigning)[0] 
Set-AuthenticodeSignature .\test.ps1 $cert

notepad test.ps1
#the signatured contains clear test version of script & name of company that signed script
#Assuming you trust the company, PowerShell will decrypt the signature with public key
#recall that when a certificate is created it includes a public & private

.\test.ps1
