#This is simple scipt that takes given login and passwords and test them against hardcoded credentials

$login = Read-Host "Enter Login " 

$password = Read-Host  "Enter Password " -MaskInput


if ($login -eq "admin") {
    Write-Host "Login correct"
}
else {
    Write-Host "Login incorrect"
}

if ($password -eq "password") {
    Write-Host "Password correct"
}
else {
    Write-Host "Password incorrect"
}

