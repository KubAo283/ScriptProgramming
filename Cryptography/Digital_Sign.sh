#!/bin/bash

#This script creates a digital signature for a file using OpenSSL.
# It requires three arguments:
# 1. The file to be signed.
# 2. The private key file (in PEM format).
# 3. The output file where the signature will be saved.
# Usage: ./Digital_Sign.sh <file_to_sign> <private_key.pem> <signature_output>


#Checking if the correct number of arguments is passed
if [ "$#" -ne 3 ]; then
    echo "Incorrect number of arguments passed!" >&2
    exit -1
fi

# Assigning arguments to variables
FILE_TO_SIGN="$1"
PRIVATE_KEY="$2"
SIGNATURE_OUTPUT="$3"

#Creating the digital signature using SHA-256
openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "$SIGNATURE_OUTPUT" "$FILE_TO_SIGN"

#Checking if the signing was successful
if [ $? -eq 0 ]; then
    echo "File signed successfully. Signature saved to $SIGNATURE_OUTPUT"
else
    echo "Signing failed!" >&2
    exit -1
fi
