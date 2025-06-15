#!/bin/bash

#This is a simple script that takes the given number and check wheter it is even and positive

read -p "Enter your number: " number

if [ $number -gt 0 ] && [ $(($number % 2)) -eq 0 ]; then
    echo "The $number is greater than zero and even"
elif [ $number -gt 0 ] && [ $(($number % 2)) -ne 0 ]; then
    echo "The $number is greater than zero and odd"
elif [ $number -lt 0 ] && [ $(($number % 2)) -eq 0 ]; then
    echo "The $number is lower than 0 and even"
else
    echo "The $number is lower than 0 and odd"
fi

