#!/bin/bash

#How does it work?
: <<'END_COMMENT' 
This script is intended to create backup of a given files, compress them into archive
and then send them to sftp server. 
END_COMMENT

# Defining files to backup 
FILES_TO_BACKUP=("$HOME/Desktop/test.txt" "$HOME/Desktop/test2.txt")

# Creating archive in /tmp directory
ARCHIVE_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"

# Compressing files into archive
tar -czf "$ARCHIVE_PATH" "${FILES_TO_BACKUP[@]}"

# Obtaining SFTP details
read -p "Enter your SFTP server: " SFTP_SERVER
read -p "Enter your username: " SFTP_USER
read -e -p "Enter path to your SSH private key: " SSH_KEY_PATH
read -e -p "Enter target directory on the remote server: " SFTP_TARGET_DIR

# Uploading files via SFTP 
sftp -i "$SSH_KEY_PATH" "$SFTP_USER@$SFTP_SERVER" <<EOF
cd $SFTP_TARGET_DIR
put "$ARCHIVE_PATH"
bye
EOF

# Cleaning up the temporary folder
rm -f "$ARCHIVE_PATH"