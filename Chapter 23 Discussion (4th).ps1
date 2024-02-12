#ForEach (Chapter 23)
1..10 | ForEach-Object -Begin {get-date} -Process {Write-Host $_
    sleep 1
} -End {get-date}

1..100 | ForEach-Object -ThrottleLimit 100 -Parallel   {Write-Host $_
    sleep 1
}
$count = 1..10
foreach ($number in $count) {
    $name = "Pat"+$number+".txt"
    Write-Host "Student info is" $name
}

#lab question 1
$files = gci 'C:\windows\Fonts'
$files | ForEach-Object -Parallel {
    Write-Host $_.Length  $_.Name
}
