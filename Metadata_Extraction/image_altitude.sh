#!/bin/bash


# This script extracts altitude data from a specified jpg file using strings and processes it.


read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi


# Extracting altitude data using strings and printing it to the console

printf "\n"
echo "Extracting altitude data from $file_path..."
printf "\n"
printf "Altitude data for %s:\n" "$file_path"

# Using strings to extract altitude information

strings "$file_path" | grep -i altitude 