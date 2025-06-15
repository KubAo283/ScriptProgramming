#!/bin/bash

#This scirpt performs basic system automation such as checking updates and upgrades, installing thunderbird, creating new user, new directories and displaying basic system info



###########################################################################
#Description: check_update function
#Globals:
#None
#Arguments:
#None
#Outputs:
#"Package list updated" if sudo apt update succesful else "Failed to update package list"
#"System is up to date" if sudo apt upgrade succesful else "Failed to upgrade the packages"
#Returns:
#None
###########################################################################

check_update() {
    echo "Checking for updates ..."
    if sudo apt update -y; then
        echo "Package list updated"
    else
        echo "Failed to update the package list"
        return 1
    fi

    if sudo apt upgrade -y; then
        echo "System is up to date"
    else
        echo "Failed to upgrade the packages"
        return 1
    fi
}


###########################################################################

#Description: client_installation function
#Globals:
#None
#Arguments:
#None
#Outputs:
#"Thunderbird is installed" if apt install thunderbird succesfull =>
#else "Thunderbird is not installed"
#Returns:
#None
###########################################################################

client_installation() {
    echo "Installing Thunderbird ..."
    sudo apt install -y thunderbird
    if command -v thunderbird &>/dev/null; then
        echo "Thunderbird is installed"
    else
        echo "Thunderbird is not installed"
    fi

	sleep 4 # Delaying the next output for 4 seconds
}


###########################################################################
#Description: add_user function
#Globals:
# name => Single input argument
# Arguments:
# name, password => Single input arguments
# Outputs:
# New user profile
# Returns:
# None
###########################################################################

add_user() {


    local name="$1"

    echo "Adding new user: $name"
    sudo useradd -m -s /bin/bash "$name" # adds new user and creates it's home directory as well as specifies the default shell

    read -s -p "Enter new password for $name: " password
    printf "\n"
    echo "$name:$password" | sudo chpasswd

    sudo usermod -aG sudo "$name" # adding the newly created user to the sudo group
    echo "New user $name has been created"

    # Display user info
    grep "$name" /etc/passwd
}


###########################################################################
#Description: create_catalogs function
#Globals:
# None
# Arguments:
# None
# Outputs:
# new catalogs  (Documents, Pictures, Videos)  at  a  ~/$name directory
# Returns:
# None
###########################################################################

create_catalogs() {
    local name="$1"
    echo "Creating directories for $name..."

    #Creating directories for a newly created user
    if sudo mkdir -p "/home/$name/Documents" "/home/$name/Pictures" "/home/$name/Videos"; then 
        echo "/home/$name/Documents /home/$name/Pictures /home/$name/Videos - directories have been successfully created"
    else    
        echo "Failed to create /home/$name/Documents /home/$name/Pictures /home/$name/Videos - directories"
    fi
}

###########################################################################
#Description: system_display function
#Globals:
# None
# Arguments:
# None
# Outputs:
# System version, ip address, mac address
# Returns:
# None
###########################################################################

system_display() {
    echo "System Information:"
    lsb_release -a | awk -F: '/Distributor ID|Description|Release/ {print $2}' | xargs
    
    ip_address=$(hostname -I | awk '{print $1}')
    mac_address=$(ip link show | awk '/ether/ {print $2; exit}')

    echo "IP Address: $ip_address"
    echo "MAC Address: $mac_address"
}

###########################################################################
# Description: main function
# Calls all other functions in sequence
###########################################################################
main() {
    

	read -p "Enter the name of a new user: " name
    add_user "$name"
	printf "\n"

    #Calling check_update
    check_update
	printf "\n"

    #Calling client_installation
    client_installation
	printf "\n"

    #Calling create_catalogs
    create_catalogs "$name"
	printf "\n"

    #Calling system_display
    printf "\n"

}

#Calling main function
main

