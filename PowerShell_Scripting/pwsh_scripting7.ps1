#This script generates simple report 

$date = (Get-Date).ToString("yyyyMMdd-HHmmss")

$file_name = "ComputerReport_$date.txt"

$lines = Get-Content -Path input_file.csv | Select-Object -Skip 1

$failed = "False"
foreach ($line in $lines) {

    $component = $line.ToString().Split(";")[0]
    $condition = $line.ToString().Split(";")[1]

    if ($condition -eq "True" ) {
    
        $hash_table = Get-ComputerInfo | Select-Object -Property $component


        try {

            "$component : $($hash_table.$component)" | Add-Content $file_name

        }

        catch 
        {
            Write-Host "An error occurred: $_"
            $failed = "True"

        }

    }

}

$path = (Resolve-Path -Path $file_name).Path

if ( $failed -eq "False" ) {

    Write-Host "The Report has been written to $file_name : $path "
 
}

else {

    Write-Host "Failed to write the report to a $file_name : $path "
}