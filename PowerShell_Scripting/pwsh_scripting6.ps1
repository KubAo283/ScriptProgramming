$lines = Get-Content -Path input_file.csv | Select-Object -Skip 1

foreach ($line in $lines) {

    $component = $line.ToString().Split(";")[0]
    $condition = $line.ToString().Split(";")[1]

    if ($condition -eq "True" ) {
    
        $hash_table = Get-ComputerInfo | Select-Object -Property $component

        Write-Host "$component : $($hash_table.$component)"


    }

}