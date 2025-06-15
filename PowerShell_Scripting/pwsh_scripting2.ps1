#This is a simple scirpt that takes a number and decides wheter it is greater than 10 or not

[int]$number = Read-Host "Enter the number "

if ($number -gt 10) {
    Write-Host "The number is greater than 10."
}
else {
    Write-Host "The number is less than or equal to 10."
}