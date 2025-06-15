#!/bin/bash

#This script checks wheter passed username and password matches hardcoded credentials

read -p "Enter your uname: " uname

read -p "Enter your password: " password

if [ $uname = "admin" ] && [ $password = "password" ]; then
	echo "Your username and password are correct"
elif [ $uname = "admin" ] && [ $password != "password" ]; then
	echo "Your password is incorrect"
elif [ $uname != "admin" ] && [ $password = "password" ]; then
        echo "Your username is incorrect"
elif [ $uname != "admin" ] && [ $password != "password" ]; then
        echo "Your username and password are incorrect"
fi

