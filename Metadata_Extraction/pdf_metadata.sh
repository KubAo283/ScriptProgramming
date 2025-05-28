#!/bin/bash


# This script extracts metada from a specified PDF file and processes it.

read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi

# Extracting metadata using pdfinfo and printing it to the console

printf "\n"
echo "Extracting metadata from $file_path..."
printf "\n"
printf "Metadata for %s:\n" "$file_path"
printf "\n"

# Using pdfinfo to extract metadata


pdfinfo "$file_path" 

