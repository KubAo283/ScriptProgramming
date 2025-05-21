#!/bin/bash

#How does it work?
: <<'END_COMMENT' 
This script is intended to log in to an ssh server, perform given commands, such as listing processes
or files etc. and write the output of these actions to a file on a local machine
END_COMMENT

# Login Credentials
REMOTE_USER="kali" # your_username
REMOTE_HOST="localhost" # ip_address or hostname
REMOTE_PORT=22  # default port
KEY_PATH="~/.ssh/id_ed25519"  # private key path

# Output file name
OUTPUT_FILE="$HOME/Desktop/test.txt"

# Commands to execute on a remote server
COMMANDS="ps aux"

# Excecute commands and write them to a file
echo "Connecting with $REMOTE_HOST..."
ssh -i "$KEY_PATH" -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST" ""$COMMANDS" > "$OUTPUT_FILE""

# Checking if ssh command was succesful
if [ "$SSH_EXIT_STATUS" -eq 0 ]; then
    echo "Results written to $REMOTE_OUTPUT_FILE on remote machine."
else
    echo "SSH failed or remote command error. Exit code: $SSH_EXIT_STATUS"
fi


