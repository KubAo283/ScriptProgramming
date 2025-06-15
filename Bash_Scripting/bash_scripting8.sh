#!/bin/bash

#This scirpt does the same as the previous one, but using while loop

n=1
# bash until loop
while [ $n -lt 11 ]; do
        echo "192.168.1.$n"
        n=$((n+1))
done

