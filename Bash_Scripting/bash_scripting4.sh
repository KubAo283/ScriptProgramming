#!/bin/bash

# This script checks if a file exists, is not empty, and whether it is a directory or not.

# Prompting user for a filename
read -p "Enter filename: " file_name

# Using locate to find the file, and taking the first result
file_path=$(locate "$file_name" | head -n 1)


# If locate does not find the file, use the provided filename directly
if [ -z "$file_path" ]; then
    file_path=$file_name
fi

# Checking if the file is not empty
if [ -e "$file_path" ]; then
    echo "File exists"
else
    echo "File does not exist"
    exit 1
fi

# Checking is the file size is greater than zero
if [ -s "$file_path" ]; then
    echo "File is not empty"
else
    echo "File is empty"
fi

# Checking if the file is a directory
if [ -d "$file_path" ]; then
    echo "File is a directory"
else
    echo "File is not a directory"
fi