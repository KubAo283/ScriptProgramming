#!/bin/bash

#This script generates 10 ip addresses starting from 192.168.1.1

# Loop from 1 to 10
for i in  $(seq 1 10); do
    echo "192.168.1.$i"
done

