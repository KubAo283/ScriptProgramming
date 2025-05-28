#!bin/bash


# This script removes all metadata from a specified jpg file


read -p "Enter the path to the file: " file_path
file_path="${file_path/#\~/$HOME}"
if [[ ! -f "$file_path" ]]; then
    echo "File not found!"
    exit 1
fi


# Removing metadata using exiftool and printing it to the console

printf "\n"
echo "Removing metadata from $file_path..."
printf "\n"

# Using exiftool to remove metadata

exiftool -all= -overwrite_original "$file_path"



