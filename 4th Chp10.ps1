#Q1
Get-Hotfix -computerName (get-adcomputer -filter {name -like '*Server*'} | Select-Object -expand name) 
#Q2
get-adcomputer -filter {name -like '*Server*' } | Get-Hotfix
#Q3
get-adcomputer -filter  {name -like 'Server2019*' }  | foreach {Get-HotFix -ComputerName $_.name}
#Q4
$names = get-adcomputer -filter  {name -like 'Server2019*' } | Select-Object -expandproperty name
Get-HotFix -ComputerName $names
#Q5
Get-Process -computername (get-adcomputer -filter {name -like '*Server*'} | Select-Object -expand name)

#region Q6
#I found the following online to delete all users with a name property that begins with 'User'
#This will delete all users
get-aduser -Filter "name -like 'user*'" | Remove-ADUser -Confirm:$false

#A .csv file was created as described in Chapter 9, question 6
Get-content .\Chp9Q6.csv

#this will output the contents of the .csv as 3 objects
#each object contains the folloing properties - name, company, city, title
Import-Csv .\Chp9Q6.csv

#The following 3 lines are a single command.  The last character
#on each line is a '|' so PowerShell knows that the command continues
#on the following line
#The following creates three users 
Import-Csv C:\users\Administrator\Chp9Q6.csv |
Select-Object name, company, city, title, @{n='samAccountName'; e={$_.Name}}|
New-ADUser

#Display all users with a name propert that begins with 'User'
get-aduser -Filter "name -like 'user*'"

#The following will change the user passwords & enable their accounts
get-aduser -Filter "name -like 'user*'" | Set-ADAccountPassword -Reset `
-NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) `
-PassThru | Enable-ADAccount
#endregion Q6

#Q6 - FWIW
 get-aduser -Filter "name -like 'user*'" | Set-ADAccountPassword -Reset `
-NewPassword (ConvertTo-SecureString -AsPlainText 'Pa$$w0rd' -Force) `
-PassThru | Enable-ADAccount 
