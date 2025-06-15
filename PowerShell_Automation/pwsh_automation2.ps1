<#
.SYNOPSIS
    This scirpt checks if a given file is malicious or not by uploading it to VirusTotal and checking the results.
.DESCRIPTION
    This script cacluates the sha256 of a given file and then sends a request to 
    VirusTotal API to check if it possibly contains malicious code or not, and then
    interprets the revceived outcome
    If the file has already been scanned, it retrieves the scan results.
.PARAMETER None
   The script does not require any parameters to be passed at runtime.
   It will prompt for the file name and API key interactively.
.EXAMPLE
    PS> .\pwsh_automation2.ps1
.NOTES
   -Note that you need to have a valid API key from VirusTotal to use this script.
#>

# Get file name
$file_name = Read-Host "Enter file name"

# Check if file exists
if (-Not (Test-Path $file_name)) {
    Write-Host "Error: File does not exist!" -ForegroundColor Red
    exit
}

# Getting full file path
$file_path = (Get-Item $file_name).FullName

# Calculating SHA256 checksum
$sha256 = Get-FileHash -Path $file_path -Algorithm SHA256
$hash = $sha256.Hash
Write-Host "Checksum of $file_name is $hash"

# Prompting for API key
$api_key = Read-Host "Enter your API key (input will be hidden)" -AsSecureString


# Converting api key to plain text and storing it in unmanaged memory, otherwise it wouldn't be possible to upload it to VirusTotal
$api_key_plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key)
)

#Creating headers, to pass them to VirusTotal request
$headers = @{ "x-apikey" = $api_key_plain }
$lookup_url = "https://www.virustotal.com/api/v3/files/$hash"


#Checking if file has already been scanned, and exists in VirusTotal database

try {
    $hash_lookup_response = Invoke-RestMethod -Uri $lookup_url -Method GET -Headers $headers -ErrorAction Stop

    $malicious_count = $hash_lookup_response.data.attributes.last_analysis_stats.malicious

    if ($malicious_count -gt 0) {
        Write-Host "The file is malicious (found $malicious_count detections)" -ForegroundColor Red
        exit
    }
    elseif ($malicious_count -eq 0) {
        Write-Host "The file is safe (no detections)" -ForegroundColor Green
        exit
    }
}
catch {
    Write-Host "No existing scan found, proceeding to upload..." -ForegroundColor Yellow
}



# Manually uploading the file to VirusTotal 


$upload_url = "https://www.virustotal.com/api/v3/files"
$form = @{
    "file" = Get-Item $file_path
}
$upload_response = Invoke-RestMethod -Uri $upload_url -Method POST -Headers $headers -Form $form

# Fetching  the scan id  of an uploaded file

$scan_id = $upload_response.data.id

if (-not $scan_id) {
    Write-Host "Failed to retrieve Scan ID. Upload response:" -ForegroundColor Red
    $upload_response | ConvertTo-Json -Depth 5
    exit
}

Write-Host "Scan ID: $scan_id"
Write-Host "Waiting for analysis to complete..." -ForegroundColor Cyan


Start-Sleep -Seconds 10  # Wait for processing

$analysis_url = "https://www.virustotal.com/api/v3/analyses/$scan_id"

$report_response = Invoke-RestMethod -Uri $analysis_url -Method GET -Headers $headers

$malicious_count = $report_response.data.attributes.stats.malicious

# Finally checking if a file is malicious or not

if ($malicious_count -gt 0) {
    Write-Host "The file is malicious ($malicious_count detections)" -ForegroundColor Red
}
else {
    Write-Host "The file is safe" -ForegroundColor Green
}