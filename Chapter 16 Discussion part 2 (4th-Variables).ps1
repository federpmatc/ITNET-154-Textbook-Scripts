#https://learn.microsoft.com/en-us/previous-versions/technet-magazine/hh551144(v=msdn.10)?redirectedfrom=MSDN
#Windows PowerShell: Scripting Crash Course
$var = 'hello'
$number = 1
$numbers = 1,2,3,4,5,6,7,8,9

$name = 'Don'
$prompt = "My name is $name"
$prompt = 'My name is $name'

#Within Double Quotes we can have escape characters (Backtick)
$debug = "`$computer contains $computer"
$head = "Column`tColumn`tColumn"

#use Double quotes when a string contains single quote
$filter1 = "name='BITS'"
$computer = 'BITS'
$filter2 = "name='$computer'"

$var = 'Hello'
$var | Get-Member   #Everything in PowerShell is an object

$svc = Get-Service
$svc[0].name
$name = $svc[1].name #The period means, “I don’t want that entire object. I just want a property or method
$name.length
$name.ToUpper()   #Methods always use parentheses.  Some methods allow for input

$service = 'bits'
$name = "Service is $service.ToUpper()" #PowerShell thinks we're only referring to the variable (not the method)
$name
$upper = $name.ToUpper()
$name = "Service is $upper"
$name
$service = 'bits'
$name = "Service is $($service.ToUpper())" #PowerShell thinks we're only referring to the variable (not the method)
$name

#parentheses also act as an order-of-execution marker for Windows PowerShell
$name = (Get-Service)[0].name
Get-Service -computerName (Get-Content names.txt)
