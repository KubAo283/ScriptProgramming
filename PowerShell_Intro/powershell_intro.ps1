# This powershell script provides an introduction to PowerShell, including basic commands and concepts.

#Creating new file

New-Item -Name "file.txt" -Type "File"

#Renaming the file

Rename-Item -Path "file.txt" -NewName "new_file.txt"

#Checking file checksum

Get-FileHash -Path "new_file.txt" -Algorithm SHA256

#Opening notepad

Start-Process Notepad

#Listing all files in a folder sorted by name

Get-ChildItem | Sort-Object { $_.Name.Length }

#Assigning output of a command to variable

$location = Get-Location

#Assigning previous output to a file

$location | Out-File -FilePath "location.txt"

#OR

Write-Output $location > "location.txt"
Get-Content "location.txt"

#Listing top 5 processes with only Name and ID columns

Get-Process | Select-Object -Property Name, Id -First 5

#Listing top 5 processes with the highest memory usage

Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -Property Name, WorkingSet -First 5

#Listing top 5 processes with the lowest memory usage, and changing the column name

Get-Process | Sort-Object -Property WorkingSet | Select-Object -First 5 @{Name = "Name"; Expression = { $_.Name } }, @{Name = "MemoryUsage"; Expression = { $_.WorkingSet}}