#!/bin/bash

# This script extracts geolocation data from a specified file and processes it.


read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi

# Extracting geolocation data using exiftool and printing it to the console
printf "\n"
echo "Extracting geolocation data from $file_path..."
printf "\n"
printf "Geolocation data for %s:\n" "$file_path"
printf "\n"

# Using exiftool to extract GPS information
exiftool "$file_path" | grep GPS | awk -F': ' 'BEGIN { printf "%-32s | %-30s\n", "Description", "Value"; print "---------------------------------+--------------------------------------------------"; } { printf "%-30s | %-30s\n", $1, $2 }'
