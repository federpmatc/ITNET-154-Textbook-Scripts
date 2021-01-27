Get-ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy AllSigned
New-Item -Name test.ps1
Add-Content -Path "test.ps1" -Value 

New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -Subject "CN=Local Code Signing" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature  -Type CodeSigningCert

certmgr /s my
#copy paste certificate from 

$cert = @(Get-ChildItem cert:\CurrentUser\My -CodeSigning)[0] 
Set-AuthenticodeSignature .\test.ps1 $cert

notepad test.ps1
.\test.ps1
