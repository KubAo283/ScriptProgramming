#This scirpt displays basic system info in PowerShell


Function Show-Hostname {
    $hostname = $env:COMPUTERNAME
    Write-Host "Nazwa hosta: $hostname"
}

Function Show-DiskUsage {
    Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
        Write-Host "Dysk: $($_.Name) | Wolne: $([math]::Round($_.Free/1GB,2)) GB | Całkowite: $([math]::Round($_.Used/1GB + $_.Free/1GB,2)) GB"
    }
}

Function Show-IP {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1' }).IPAddress
    Write-Host "Adres IP: $ip"
}

Function Show-MAC {
    $mac = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).MacAddress
    Write-Host "Adres MAC: $mac"
}

Function Show-OSVersion {
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $ver = (Get-CimInstance Win32_OperatingSystem).Version
    Write-Host "Wersja systemu operacyjnego: $os ($ver)"
}

# Wywołanie funkcji
Show-Hostname
Show-DiskUsage
Show-IP
Show-MAC
Show-OSVersion