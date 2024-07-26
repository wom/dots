#!/bin/bash

set -euo pipefail

# Define the virtual environment directory and Ansible version
VENV_DIR="$HOME/venvs/ansible_venv"
ANSIBLE_VERSION="2.9.10" # Example version, adjust as needed

# Check for Python and pip availability
if ! command -v python3 &> /dev/null; then
    echo "Python3 could not be found"
    exit 1
fi

# Create a directory for virtual environments if it doesn't exist
echo "Creating virtual environments directory..."
mkdir -p ~/venvs

# verify venv available
sudo apt update && sudo apt install -y python3 python3-venv

# Check if the virtual environment already exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment already exists. Consider removing it before running this script again."
    exit 1
fi

# Create a virtual environment
echo "Creating a virtual environment..."
python3 -m venv "$VENV_DIR"

# Activate the virtual environment
(
    echo "Activating the virtual environment..."
    source "$VENV_DIR/bin/activate"

    # Install Ansible
    echo "Installing Ansible version $ANSIBLE_VERSION..."
    pip install "ansible==$ANSIBLE_VERSION"

    echo "Ansible installation completed successfully."
)