#!/bin/bash

#This script displays basic info about device it is executed on, such as: date, current version of software, loggedd in user and IP Address

device_name=$( echo $HOSTNAME )

function current_date (){
    echo "Current date on a $1 device is: $(date)"
}

function version(){
    echo "Current version of linux on a $1 device is: $(lsb_release -a | grep Distributor | cut -d: -f2 | xargs)"
    #OR
    echo "Current version of linux on a $1 device is: $(uname -r)"
}

function user(){
    echo "Current user on a $1 device is: $USER"
}

function IPAddress(){
	echo "Current ipaddress on a $1 device is: $(ip address | grep eth0 | grep inet | awk '{print $2}') "
    #OR
    echo "Current ipaddress on a $1 device is: $(hostname -I)"

}


main() {

current_date $device_name
version $device_name
user $device_name
IPAddress $device_name

}

main

