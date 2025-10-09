#Q1
Get-Random  #between 0 and 2 billion [int32]::maxvalue
#Check out the online help to see how easy it is to use get-random

#Q2
Get-Date

#Q3
get-date | Get-Member  #System.DateTime

#Q4
get-date |Select-Object  DayOfWeek

#Q5
Get-ChildItem | Get-Member  #We see that there is a lastwritetime property
Get-ChildItem -Path ~ -File | Select-Object Name, LastWriteTime

#Q6
Get-ChildItem ~ -File | Select-Object name, LastWriteTime
Get-ChildItem ~ -File | get-member #Creation Time
Get-ChildItem ~ -File | Sort-Object -Descending -Property CreationTime | Select-Object Name, CreationTime

#Q7
Get-ChildItem ~ -File | Sort-Object -Descending -Property LastWriteTime | Select-Object Name, LastWriteTime
Get-ChildItem ~ -File | Sort-Object -Descending -Property LastWriteTime | Select-Object Name, LastWriteTime | Export-csv -Path ~\Question7.csv
