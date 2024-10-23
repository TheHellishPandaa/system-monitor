#!/bin/bash

# Clear the terminal
clear

# Show a welcome message
echo "*******************************************************************"
echo "****** MONITORING CPU, MEMORY, DISK AND NETWORK INFORMATION *******"
echo "*******************************************************************"

echo "To run this script successfully, please ensure 'curl' is installed. You can install it using: 'snap install curl' or 'apt install curl'"
echo

# Function to get the hostname
get_HOSTNAME() {
    HOSTNAME=$(cat /etc/hostname)
}

# Function to get CPU usage
get_cpu_usage() {
    echo "CPU USAGE:"
    top -bn1 | grep "Cpu(s)" | awk '{printf "CPU in use: %.2f%%\n", $2 + $4}'
}

# Function to get memory usage in GB
get_memory_usage() {
    echo "MEMORY USAGE:"
    free -m | grep Mem | awk '{printf "Memory used: %.2fGB of %.2fGB\n", $3/1024, $2/1024}'
}

# Function to get disk usage
get_disk_usage() {
    echo "DISK USAGE:"
    df -h / | grep / | awk '{print "Disk usage: " $5 " (" $3 " used of " $2 ")"}'
}

# Function to get swap memory usage
get_swap_usage() {
    echo "SWAP USAGE:"
    free -m | grep Swap | awk '{printf "Swap used: %.2fGB of %.2fGB\n", $3/1024, $2/1024}'
}

# Function to get the network interface in use
get_network_interface() {
    interfaz=$(ip route | grep '^default' | awk '{print $5}')
    if [[ -z "$interfaz" ]]; then
        echo "A network interface could not be detected."
        return 1
    fi
    echo "Your network interface is: $interfaz"
}

# Function to get local IP
get_local_ip() {
    echo "LOCAL IP:"
    hostname -I
}

# Function to get MAC address
get_DIR_MAC() {
    echo "MAC ADDRESS:"
    interfaz=$(ip route | grep '^default' | awk '{print $5}')
    cat /sys/class/net/$interfaz/address
}

# Function to get the default gateway
get_DEFAULT_GATEWAY() {
    echo "DEFAULT GATEWAY:"
    ip route show default
}

# Function to get the public IP
get_public_ip() {
    echo "PUBLIC IP:"
    PUBLIC_IP=$(curl -s ifconfig.me)
    if [[ -n "$PUBLIC_IP" ]]; then
        echo "Public IP: $PUBLIC_IP"
    else
        echo "Could not obtain your Public IP Address. Check your Internet connection."
    fi
}

# Function to check internet connection
get_INTERNET_CONNECTION() {
    echo "INTERNET CONNECTION:"
    var=$(curl -s --head http://www.google.com | head -n 1)
    if [[ $var == *"200 OK"* ]]; then
        echo "Internet Connection: Active"
    else
        echo "No internet connection detected. Please check your network adapter and rerun the script."
    fi
}

# Get system information
echo "-----------------------------------"
echo "The Hostname of the system is: $HOSTNAME"
echo "-----------------------------------"
get_cpu_usage
echo "-----------------------------------"
get_memory_usage
echo "-----------------------------------"
get_disk_usage
echo "-----------------------------------"
get_swap_usage
echo "-----------------------------------"
get_network_interface
echo "-----------------------------------"
get_local_ip
echo "-----------------------------------"
get_DIR_MAC
echo "-----------------------------------"
get_DEFAULT_GATEWAY
echo "-----------------------------------"
get_public_ip
echo "-----------------------------------"
get_INTERNET_CONNECTION
echo "-----------------------------------"
