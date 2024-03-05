#ForEach (Chapter 23)
1..10 | ForEach-Object -Begin {get-date} -Process {Write-Host $_
    sleep 1
} -End {get-date}

Measure-Command {
1..10 | ForEach-Object -Process { Write-Host $_   
    sleep 1  }  
}

#the default throttle limit is 5
Measure-Command {
1..100 | ForEach-Object -ThrottleLimit 100 -Parallel   {Write-Host $_
    sleep 1}
}

$count = 1..10
foreach ($number in $count) {
    $name = "Pat"+$number+".txt"
    Write-Host "Student info is" $name
}

#lab question 1
$files = gci -Path ~ -File
$files | ForEach-Object -Parallel {
    Write-Host "$($_.Length)`t $($_.Name)"
}
