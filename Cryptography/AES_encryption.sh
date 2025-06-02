#!/bin/bash

# This script encrypts a file using AES encryption with OpenSSL. It requires two arguments:
# 1. The input file to be encrypted.
# 2. The output file where the encrypted data will be saved.
# Usage: ./AES_encryption.sh <input_file> <output_file>

#Checking if the correct number of arguments is passed
if [ "$#" -ne 2 ]; then
    echo "Incorrect number of arguments passsed!" >&2
    exit -1
fi

# Prompting for password
read -sp "Enter password: " PASSWORD
echo

# Encrypt the file using AES-256-CBC
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$1" -out "$2" -pass pass:"$PASSWORD"

# Checking if the encryption was successful
if [ $? -eq 0 ]; then
    echo "Encryption successful, the output will be stored in $2 file."
else
    echo "Encryption failed!" >&2
    exit -1
fi

