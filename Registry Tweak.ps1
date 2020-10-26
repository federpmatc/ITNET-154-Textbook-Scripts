#12 Registry tweaks - https://www.maketecheasier.com/windows-10-registry-hacks/

#Tweak #11 - https://www.maketecheasier.com/how-to-hide-onedrive-from-file-explorer-windows-10/ 
#How to Hide OneDrive from File Explorer in Windows 10

New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
get-psdrive
Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0
Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0

