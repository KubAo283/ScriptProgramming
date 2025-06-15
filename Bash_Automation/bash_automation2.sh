#!/bin/bash

: '
This script cacluates the sha256 of a given file and then sends a request to 
VirusTotal API to check if it possibly contains malicious code or not, and then
interprets the revceived outcome
'

# Get file name
read -p "Enter file name: " file_name

# Ensuring the file exists
if [[ ! -f "$file_name" ]]; then
    echo "File does not exist"
    exit 1
fi

# Getting file absolute path
file_path=$(realpath $(locate "$file_name" | head -n 1) )

# Calculating SHA256 checksum
check_sum=$(sha256sum "$file_path" | awk '{print $1}')
echo "Checksum of $file_name is $check_sum"

# Getting API key
read -s -p "Enter your API key: " api_key
printf "\n"

#Checking if file has already been scanned
response=$(curl --silent --request GET \
  --url "https://www.virustotal.com/api/v3/files/$check_sum" \
  --header "x-apikey: $api_key")

printf "\n"

#Obtaining scan results, checking if the file is malicious
results=$(echo "$response" | jq -r '.data.attributes.last_analysis_stats.malicious')

if [[ -n "$results" && "$results" -gt 0 ]]; then
    echo "The file is malicious (previous scan found $results malicious detections)"
    exit 0
elif [[ -n "$results" && "$results" -eq 0 ]]; then
    echo "The file is safe (previous scan found no malicious detections)"
    exit 0
fi


#If no existing file scan has been found, uploading the file
upload=$(curl --silent --request POST \
  --url "https://www.virustotal.com/api/v3/files" \
  --header "x-apikey: $api_key" \
  --form "file=@$file_path")

scan_id=$(echo "$upload" | jq -r '.data.id')

if [[ -z "$scan_id" || "$scan_id" == "null" ]]; then
    echo "Failed to retrieve scan ID. Check API response:"
    echo "$upload"
    exit 1
fi


echo "Waiting for analysis..."

#Waiting for scan results
sleep 10

response=$(curl --silent --request GET \
  --url "https://www.virustotal.com/api/v3/analyses/$scan_id" \
  --header "x-apikey: $api_key")

#Obtaining scan results, checking if the file is malicious
results=$(echo "$response" | jq -r '.data.attributes.last_analysis_stats.malicious')

if [[ -n "$results" && "$results" -gt 0 ]]; then
    echo "The file is malicious (previous scan found $results malicious detections)"
    exit 0
elif [[ -n "$results" && "$results" -eq 0 ]]; then
    echo "The file is safe (previous scan found no malicious detections)"
    exit 0
fi

