#!/bin/bash

echo "=========================================="
echo "Sudo Permissions Fix Script"
echo "=========================================="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root (not with sudo)"
    echo "Please run: su - "
    echo "Then execute this script"
    exit 1
fi

echo "Checking current sudo-related file permissions..."
echo ""

# Display current permissions
echo "Current permissions:"
ls -la /usr/lib/sudo/sudoers.so 2>/dev/null || echo "sudoers.so not found"
ls -la /etc/sudoers 2>/dev/null || echo "/etc/sudoers not found" 
ls -ld /usr/lib/sudo 2>/dev/null || echo "/usr/lib/sudo directory not found"

echo ""
echo "=========================================="
echo "Do you want to fix sudo permissions? (yes/no)"
read -r choice

if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
    echo "Starting sudo permissions fix..."
    echo ""
    
    # Fix sudoers.so permissions
    if [[ -f /usr/lib/sudo/sudoers.so ]]; then
        echo "Fixing /usr/lib/sudo/sudoers.so permissions..."
        if chmod 644 /usr/lib/sudo/sudoers.so; then
            echo "✓ Set sudoers.so permissions to 644"
        else
            echo "✗ Failed to set sudoers.so permissions"
        fi
        
        if chown root:root /usr/lib/sudo/sudoers.so; then
            echo "✓ Set sudoers.so ownership to root:root"
        else
            echo "✗ Failed to set sudoers.so ownership"
        fi
    else
        echo "⚠ Warning: /usr/lib/sudo/sudoers.so not found"
    fi
    
    echo ""
    
    # Fix /etc/sudoers permissions
    if [[ -f /etc/sudoers ]]; then
        echo "Fixing /etc/sudoers permissions..."
        if chmod 440 /etc/sudoers; then
            echo "✓ Set /etc/sudoers permissions to 440"
        else
            echo "✗ Failed to set /etc/sudoers permissions"
        fi
        
        if chown root:root /etc/sudoers; then
            echo "✓ Set /etc/sudoers ownership to root:root"
        else
            echo "✗ Failed to set /etc/sudoers ownership"
        fi
    else
        echo "⚠ Warning: /etc/sudoers not found"
    fi
    
    echo ""
    
    # Fix sudo directory permissions
    if [[ -d /usr/lib/sudo ]]; then
        echo "Fixing /usr/lib/sudo directory permissions..."
        if chmod 755 /usr/lib/sudo; then
            echo "✓ Set /usr/lib/sudo directory permissions to 755"
        else
            echo "✗ Failed to set /usr/lib/sudo directory permissions"
        fi
        
        if chown root:root /usr/lib/sudo; then
            echo "✓ Set /usr/lib/sudo directory ownership to root:root"
        else
            echo "✗ Failed to set /usr/lib/sudo directory ownership"
        fi
    else
        echo "⚠ Warning: /usr/lib/sudo directory not found"
    fi
    
    echo ""
    echo "Final permissions check:"
    echo "========================"
    ls -la /usr/lib/sudo/sudoers.so 2>/dev/null || echo "sudoers.so not found"
    ls -la /etc/sudoers 2>/dev/null || echo "/etc/sudoers not found"
    ls -ld /usr/lib/sudo 2>/dev/null || echo "/usr/lib/sudo directory not found"
    
    echo ""
    echo "Testing sudo functionality..."
    echo "You should now be able to exit root and test: sudo -v"
    
    echo ""
    echo "Sudo permissions fix completed."
    
else
    echo "Sudo permissions fix skipped by user."
fi

echo ""
echo "=========================================="
echo "Script execution finished."
echo ""
echo "IMPORTANT: Exit root shell and test sudo with a regular user:"
echo "  exit"
echo "  sudo -v"
echo "=========================================="