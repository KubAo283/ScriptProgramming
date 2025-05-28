#!/bin/bash

# This script extracts hidden message and original file name from a Widok.JPG file

read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi


# Extracting original filename using exiftool and printing it to the console

printf "\n"
echo "Extracting original filename from $file_path..."
printf "\n"
printf "Original filename for %s: " "$file_path"
# Using exiftool to extract hidden messages
exiftool "$file_path" | grep "Image Description"| awk -F ': ' '{printf $2}' | awk -F '\' '{printf $3}'

printf "\n"

# Extracting hidden message using exiftool and printing it to the console
printf "\n"
echo "Extracting hidden message from $file_path..."
printf "\n"
printf "Hidden message for %s: " "$file_path"
# Using exiftool to extract hidden messages

exiftool -XPComment "$file_path" | awk -F ': ' '{printf $2}'

