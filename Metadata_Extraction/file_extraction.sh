#!/bin/bash

# This script extracts embedded files from a jpg file and processes them.

read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi


# Extracting embedded files using exiftool and printing it to the console

printf "\n"
echo "Extracting embedded files from $file_path..."
printf "\n"
printf "Embedded files for %s:\n: " "$file_path"

# Using exiftool to extract embedded files

binwalk -i "$file_path"


