<#
.SYNOPSIS
    This scirpt monitors if any new files were added to the source directory and moves them to the destination directory
.DESCRIPTION
    This script monitors a specified source directory for new files and moves them to a specified destination directory.
    It checks for new files every 5 seconds and moves them if they are not already present in the destination directory.
    If the destination directory does not exist, it will create it.
.PARAMETER SourceDirectory
    The directory to monitor for new files.
.PARAMETER DestinationDirectory
    The directory where new files will be moved.
.EXAMPLE
    PS> .\pwsh_automation1.ps1
.NOTES
    None
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDirectory,

    [Parameter(Mandatory = $true)]
    [string]$DestinationDirectory
)

# Checking if the source directory exists
if (-not (Test-Path -Path $SourceDirectory -PathType Container)) {
    Write-Error "Source directory '$SourceDirectory' does not exist. Exiting."
    exit 1
}

# Checking if the destination directory exists, creating it if it doesn't
if (-not (Test-Path -Path $DestinationDirectory -PathType Container)) {
    try {
        Write-Host "Destination directory '$DestinationDirectory' does not exist. Creating it..."
        New-Item -Path $DestinationDirectory -ItemType Directory -Force | Out-Null
    }
    catch {
        Write-Error "Failed to create destination directory '$DestinationDirectory'. Exiting."
        exit 1
    }
}

Write-Host "Monitoring directory '$SourceDirectory' for new files. Moving them to '$DestinationDirectory'."
Write-Host "Press CTRL+C to stop the script."

# While Loop
while ($true) {

    # Getting the current list of files in the source directory
    $NewFiles = Get-ChildItem -Path $SourceDirectory -File
    Write-Host "Current files: $($NewFiles | Select-Object -ExpandProperty Name)" 

    # Comparing if CurrentFiles is not null
    if ($CurrentFiles) {
        $AddedFiles = Compare-Object -ReferenceObject $CurrentFiles -DifferenceObject $NewFiles -Property Name -PassThru | Where-Object { $_.SideIndicator -eq "=>" }

        if ($AddedFiles) {
            Write-Host "Detected new files: $($AddedFiles | Select-Object -ExpandProperty Name)"
            foreach ($File in $AddedFiles) {
                $SourcePath = Join-Path -Path $SourceDirectory -ChildPath $File.Name
                $DestinationPath = Join-Path -Path $DestinationDirectory -ChildPath $File.Name

                Write-Host "Attempting to move '$($File.Name)' from '$SourcePath' to '$DestinationPath'."
                try {
                    Move-Item -Path $SourcePath -Destination $DestinationPath -Force -ErrorAction Stop
                    Write-Host "Successfully moved '$($File.Name)' to '$DestinationDirectory'."
                }
                catch {
                    Write-Error "Error moving file '$($File.Name)': $($_.Exception.Message)"
                }
            }
        }
        else {
            Write-Host "No new files detected."
        }
    }
    else {
        # Comparing if CurrentFiles is null and NewFiles is not null
        if ($NewFiles) {
            Write-Host "Detected initial files: $($NewFiles | Select-Object -ExpandProperty Name)"
            foreach ($File in $NewFiles) {
                $SourcePath = Join-Path -Path $SourceDirectory -ChildPath $File.Name
                $DestinationPath = Join-Path -Path $DestinationDirectory -ChildPath $File.Name

                Write-Host "Attempting to move initial file '$($File.Name)' from '$SourcePath' to '$DestinationPath'."
                try {
                    Move-Item -Path $SourcePath -Destination $DestinationPath -Force -ErrorAction Stop
                    Write-Host "Successfully moved initial file '$($File.Name)' to '$DestinationDirectory'."
                }
                catch {
                    Write-Error "Error moving initial file '$($File.Name)': $($_.Exception.Message)"
                }
            }
        }
        else {
            Write-Host "Source directory is still empty."
        }
    }

    # Updating $CurrentFiles for the next iteration
    $CurrentFiles = Get-ChildItem -Path $SourceDirectory -File
    Write-Host "Updated reference files: $($CurrentFiles | Select-Object -ExpandProperty Name)"
    Write-Host "---------------------------------" # Separator for each loop iteration
    Start-Sleep -Seconds 5
}
