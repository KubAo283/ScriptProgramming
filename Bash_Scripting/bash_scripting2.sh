#!/bin/bash

#This scirpt calculates the area of a rectangle

read -p "Enter length: " length
read -p "Enter width: " width

rectangle_area=$((length * width))
echo "The area of rectangle is: $rectangle_area"


