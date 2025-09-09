#!/bin/bash

# Script to update device text for Pulsar board
# Author: Sarthak

echo "Do you want to update the device text? (yes/no)"
read -r choice

if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
    echo "Updating device text..."

    # Backup original files before modification
    sudo cp /etc/issue /etc/issue.bak 2>/dev/null
    sudo cp /etc/issue.net /etc/issue.net.bak 2>/dev/null
    sudo cp /etc/os-release /etc/os-release.bak 2>/dev/null
    sudo cp /etc/update-motd.d/00-header /etc/update-motd.d/00-header.bak 2>/dev/null
    sudo cp /etc/update-motd.d/10-help-text /etc/update-motd.d/10-help-text.bak 2>/dev/null

    # Update /etc/issue
    if echo "AICRAFT Pulsar" | sudo tee /etc/issue >/dev/null; then
        echo "/etc/issue updated."
    else
        echo "Update failed, please try manual."
        exit 1
    fi

    # Update /etc/issue.net
    if echo "AICRAFT Pulsar" | sudo tee /etc/issue.net >/dev/null; then
        echo "/etc/issue.net updated."
    else
        echo "Update failed, please try manual."
        exit 1
    fi

    # Update /etc/os-release (replace PRETTY_NAME only)
    if sudo sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="AICRAFT"/' /etc/os-release; then
        echo "/etc/os-release updated."
    else
        echo "Update failed, please try manual."
        exit 1
    fi

    # Update /etc/update-motd.d/00-header (replace SDK_DESCRIPTION)
    if sudo sed -i 's|^SDK_DESCRIPTION=.*|SDK_DESCRIPTION="Welcome to AICRAFT main (custom based on ubuntu 20.04)"|' /etc/update-motd.d/00-header; then
        echo "/etc/update-motd.d/00-header updated."
    else
        echo "Update failed, please try manual."
        exit 1
    fi

    # Remove printf statements from /etc/update-motd.d/10-help-text
    if sudo sed -i '/printf/d' /etc/update-motd.d/10-help-text; then
        echo "/etc/update-motd.d/10-help-text cleaned."
    else
        echo "Update failed, please try manual."
        exit 1
    fi

    echo "Device text update completed successfully."

else
    echo "Device text update skipped by user."
fi
