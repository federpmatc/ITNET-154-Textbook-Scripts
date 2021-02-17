#https://community.spiceworks.com/how_to/153255-windows-10-signing-a-powershell-script-with-a-self-signed-certificate
#Overview - https://sid-500.com/2017/10/26/how-to-digitally-sign-powershell-scripts/
#https://sectigo.com/resource-library/public-key-vs-private-key
Get-ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy AllSigned

New-Item -path "test.ps1"  -ItemType file -force
Add-Content -Path "test.ps1" -Value "Write-host 'Hello'"
notepad test.ps1
.\test.ps1

New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -Subject "CN=Local Code Signing" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature  -Type CodeSigningCert

certmgr /s my
#copy paste certificate from 

$cert = @(Get-ChildItem cert:\CurrentUser\My -CodeSigning)[0] 
Set-AuthenticodeSignature .\test.ps1 $cert
#Signature block contains a hash of the script and name of the company that signed the script
#Public key is used to decrypt the signature block and compare with a hash of the clear text version of script

notepad test.ps1
#the signatured contains clear teXt version of script & name of company that signed script & public key
#PowerShell will decrypt the signature with public key
#Recall that when a certificate is created it includes a public & private
#The system can see if signature block was tampered with.
#The system can determine if the script has been tampered with

.\test.ps1

