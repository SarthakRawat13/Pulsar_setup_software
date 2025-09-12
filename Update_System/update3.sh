#!/bin/bash

# Function to fix sudoers permission issue
fix_sudoers() {
    echo "Fixing sudoers permission issue..."
    chmod 440 /etc/sudoers.d/README 2>/dev/null
    chmod 755 /etc/sudoers.d
}

# Function to fix repository sources
fix_repositories() {
    echo "Detected repository issues. Fixing sources.list..."
    
    # Backup current sources
    cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)
    
    # Check architecture
    ARCH=$(dpkg --print-architecture)
    
    if [[ "$ARCH" == "arm64" || "$ARCH" == "armhf" ]]; then
        echo "ARM architecture detected, using ports.ubuntu.com..."
        cat > /etc/apt/sources.list << 'EOF'
deb http://ports.ubuntu.com/ubuntu-ports focal main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports focal-updates main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports focal-backports main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports focal-security main restricted universe multiverse

deb-src http://ports.ubuntu.com/ubuntu-ports focal main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports focal-updates main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports focal-backports main restricted universe multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports focal-security main restricted universe multiverse
EOF
    else
        echo "x86/amd64 architecture detected, using archive.ubuntu.com..."
        cat > /etc/apt/sources.list << 'EOF'
deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse

deb-src http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse
EOF
    fi
    
    # Fix any additional source files
    if ls /etc/apt/sources.list.d/*.list 1> /dev/null 2>&1; then
        sed -i 's/us\.ports\.ubuntu\.com/ports.ubuntu.com/g' /etc/apt/sources.list.d/*.list 2>/dev/null
    fi
}

# Function to handle mirror sync issues
handle_mirror_sync() {
    echo "Mirror sync issues detected. Trying alternative approach..."
    
    # Remove security repos temporarily if they're causing issues
    cp /etc/apt/sources.list /etc/apt/sources.list.temp
    grep -v "focal-security" /etc/apt/sources.list.temp > /etc/apt/sources.list
    
    echo "Attempting update without security repositories..."
    if apt clean && apt update; then
        echo "Update successful without security repos. Re-adding security repositories..."
        mv /etc/apt/sources.list.temp /etc/apt/sources.list
        apt update --allow-releaseinfo-change
    else
        echo "Still having issues. Restoring original sources..."
        mv /etc/apt/sources.list.temp /etc/apt/sources.list
    fi
}

# Main update function
perform_update() {
    echo "Starting system update..."
    
    # Check for sudoers warning first
    if sudo echo "test" 2>&1 | grep -q "world writable"; then
        fix_sudoers
    fi
    
    # Attempt normal update
    UPDATE_OUTPUT=$(apt update 2>&1)
    UPDATE_EXIT_CODE=$?
    
    # Check for specific error patterns
    if echo "$UPDATE_OUTPUT" | grep -q "404.*Not Found" || echo "$UPDATE_OUTPUT" | grep -q "us\.ports\.ubuntu\.com"; then
        echo "404 errors or mixed repository sources detected!"
        fix_repositories
        echo "Cleaning package cache and retrying update..."
        apt clean
        UPDATE_OUTPUT=$(apt update 2>&1)
        UPDATE_EXIT_CODE=$?
    fi
    
    # Check for mirror sync issues
    if echo "$UPDATE_OUTPUT" | grep -q "Mirror sync in progress" || echo "$UPDATE_OUTPUT" | grep -q "File has unexpected size"; then
        echo "Mirror synchronization issues detected!"
        handle_mirror_sync
        UPDATE_OUTPUT=$(apt update 2>&1)
        UPDATE_EXIT_CODE=$?
    fi
    
    # If update still fails, try with --fix-missing
    if [ $UPDATE_EXIT_CODE -ne 0 ]; then
        echo "Update failed, trying with --fix-missing..."
        apt clean
        apt update --fix-missing
    fi
    
    # Proceed with upgrade if update was successful
    if apt update > /dev/null 2>&1; then
        echo "Package lists updated successfully. Starting upgrade..."
        if apt upgrade -y && apt install -y libjpeg-dev zlib1g-dev libpng-dev; then
            echo "System update completed successfully."
            
            # Clean up
            apt autoremove -y
            apt autoclean
            
            echo "Update summary:"
            echo "- Package lists updated"
            echo "- System packages upgraded"
            echo "- Development libraries installed"
            echo "- Cleanup completed"
        else
            echo "Package upgrade failed. Please check the output above for errors."
            return 1
        fi
    else
        echo "Failed to update package lists. Please check your internet connection and repository configuration."
        return 1
    fi
}

# Main script
echo "Enhanced System Update Script"
echo "============================="
echo "This script will detect and fix common repository issues automatically."
echo ""
echo "Do you want to update the system packages? (yes/no)"
read -r choice

if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
    perform_update
else
    echo "System update skipped by user."
fi