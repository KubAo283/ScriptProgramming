#!/bin/bash


#Part 1

#Listing all files in a given directory, including hidden files

ls -la

#Creating empty file and checking it's permissions

touch new_file.txt

ls -l new_file.txt

#Creating new directory

mkdir new_dir

#Copying created file to the new directory

cp new_file.txt new_dir

#Deleting file from it's original location

rm new_file.txt

#Moving to the new directory

cd new_dir

#Checking current working directory

pwd

#Changing permissions for a created file, using numerical values

chmod 100 new_file.txt

#Changing permissions for a newly created second file, using alphabetic values

touch second_file.txt
chmod g+rw second_file.txt
chmod o-rwx second_file.txt

#Setting full permisions for a file using one command

chmod -R 777 /home/user/Desktop/new_dir

#Changing filename

mkdir second_dir
mv second_file second_dir

#Part 2

#Finding created file using find and locate commands

sudo updatedb
find new_file.txt
locate new_file.txt

#Finding all text files in a /etc directory

find /etc -type f -name "*.txt"

#Finding all the files with a 777 permisions

find -type f -perm 777

#Part 3

#Redirecting all the data from a passwd file and counting the number of words in a file

wc -w < /etc/passwd

#Pinging localhost with 5 packets and sending the output to a given file

ping -c 5 127.0.0.1 > log.txt
cat log.txt

#Displaying info about root user from a passwd file and redirecting it to a created file

grep "root" /etc/passwd > root_info.txt

#Part 4

#Using grep command to display all the files from /etc directory containing "host" phrase

ls /etc | grep "host"

#Obtainig list of user from a /passwd file and sorting it alphabetically

cut -d : -f1 /etc/passwd | sort

#Displaying only 5 last records from a previous output

cut -d : -f1 /etc/passwd | sort | tail -n 5

#Sending 5 packets to the localhost and replacing TTL field with other value

ping -c 5 127.0.0.1 | sed 's/ttl=64/ttl=128/'

#Part 5

#Finding PID of a given running program

pidof firefox-esr

#Killing the process using it's PID

kill $( pidof firefox-esr | tail -n 1 )

#Displaying only one user's processes

ps -u kali

#Sorting processes according to the RAM usage, displaying top 5 positions

ps aux --sort=%mem | head -n 5 | column -t

#Testing jobs, fg and bg utilities

firefox &
jobs

#Use ctrl +z to stop the process

fg %1
bg %1



