#This script calculates the area of a triangle based on provided values

[int]$length = Read-Host "Enter the lenght: "

[int]$height = Read-Host "Enter the height: "

#Calcultaing the are of a triangle
$area = ($length * $height) / 2

Write-Host "The area of the rectangle is $area square units."