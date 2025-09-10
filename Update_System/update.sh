#!/bin/bash
echo "Do you want to update the system packages? (yes/no)"
read -r choice

if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
    echo "Starting system update..."
    # Update package lists and upgrade
    if sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y libjpeg-dev zlib1g-dev libpng-dev; then
        echo "System update completed successfully."
    else
        echo "Update failed. Please try manual update."
    fi
else
    echo "System update skipped by user."
fi
