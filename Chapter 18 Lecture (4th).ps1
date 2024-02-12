#Variables
#1.) Review Code Below

#PowerShell variables are preceeded by a $
#Variables can contain objects .. which is anything
$name = 'Server2016-1'

#PowerShell provides access to environment variables through env: drive
#Environment variables store information about the operating system environment.
Get-ChildItem env:

#You can retrieve a particular environment variable by $ env: <variable name>
$env:COMPUTERNAME 

$name = $env:COMPUTERNAME

Get-Service -ComputerName $name  #You can use an environment variable

$name | Get-Member
$name.Length   #Property
$name.ToUpper()  #Methods always have ()

$services = Get-Service
$services
$services[0]
$services[1]

$val = 10
$val | Get-Member

#'' vs ""
$phrase = "the computer name is $name"
$phrase

$phrase = 'the computer name is $name'  #'' are literal
$phrase

#` backtick (it's called an escape character)
#` allows you to specify a lteral character
#in double quotes, a backtick before a $ means treat it as a dollar sign.  a `n carriage return line feed
$phrase = "the computer name is `$name"
$phrase

#`t is a tab
$phrase = "the `tcomputer `tname `tis `t$name"
$phrase

#what will the following do?
$phrase = "the computer name is `$$name "
$phrase

#special characters
$phrase = "the computer `t name is`n `$$name "
$phrase

#array of objects
$names = 'Server2016-1', 'Server2016-2', 'LocalHost'
$names

$names[0]
$names[1]

$names | gm

#We can access the properties & execute methods on objects
$names
$names | gm  #We see methods & properties

$names.Length
$names[0].length
$names[0]
$names[0].ToLower()

#Working with multiple objects
#We are going to do something for each object
$names | ForEach-Object {$_.toUpper() }
$names #we did not change the objects

$UpperNames = $names | ForEach-Object {$_.toUpper() }

#https://community.spiceworks.com/topic/1463339-powershell-path-variables-with-spaces
ForEach ($name in $names) 
{
New-Item -Path "C:\" -Name $Name -ItemType Directory
}


#Objects
$services = Get-Service
$services.name #we can access the property of multiple objects

#this is equivalent to
Get-Service | Select-Object name  #recall select object selects properties

#The Foreach statement (also known as a Foreach loop) 
#is for stepping through (iterating) a series of values in a collection of items.
ForEach ($service in $services) 
{
$service.name
}

#ForEach-Object accepts a collection of object as input and then iterates through them
$services | ForEach-Object {$_.name}

#variable types
$number = Read-Host "Pick a number"
$answer = "10" * $number
write-host $number "* 10 equals" $answer  #????

[int]$number  = Read-Host "Pick a number"
$number
$number*10  #:)
