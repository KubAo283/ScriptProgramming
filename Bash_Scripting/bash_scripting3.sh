#!/bin/bash

# This script check if the given username matches the current hostname.

# Prompting user for a username
read -p "Enter your username: " user
username=$(echo $HOSTNAME)


if [[ $user == "$username" ]]; then
	echo "This is an Admin Account"
else
	echo "This is not Admin Account"
fi



