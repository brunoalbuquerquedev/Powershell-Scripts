#!/bin/bash

# Update system packages
apt update
apt upgrade -y

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run as root to install GCC."
    exit 1
fi

# Check if the parameter is provided via command line
if [ -z "$1" ]; then
    echo "No parameter provided."
    echo "Usage: $0 [a|g]"
    echo "b - install build-essential"
    echo "c - install only gcc"
    echo "d - install gcc-doc"
    echo "g - install only g++"
    echo "Please enter the parameter:"
    read p
else
    p=$1
fi

# Install the packages according to the parameter
if [ "$p" == "b" ]; then
    echo "Installing build-essential..."
    sudo apt install build-essential -y
elif [ "$p" == "c" ]; then
    echo "Installing GCC..."
    sudo apt install gcc -y
elif [ "$p" == "d" ]; then
    echo "Installing GCC Documentation"
    sudo apt install gcc-doc -y
elif [ "$p" == "g" ]; then
    echo "Installing the G++"
    sudo apt install g++
else
    echo "Invalid parameter."
    exit 1
fi

# Check if GCC was successfully installed
if command -v gcc >/dev/null 2>&1; then
    echo "GCC version installed:"
    gcc --version
else
    echo "GCC is not installed."
fi
