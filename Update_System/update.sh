#!/bin/bash

echo "=========================================="
echo "SSH Service Diagnostic and Fix Script"
echo "=========================================="

# Check current SSH service status
echo "Checking current SSH service status..."
systemctl status ssh.service --no-pager

echo ""
echo "Recent SSH service logs:"
journalctl -u ssh.service -n 20 --no-pager

echo ""
echo "=========================================="
echo "Do you want to fix SSH service permissions and restart? (yes/no)"
read -r choice

if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
    echo "Starting SSH service fix..."
    echo ""
    
    # Fix SSH host key permissions
    echo "Fixing SSH host key permissions..."
    if chmod 600 /etc/ssh/ssh_host_* 2>/dev/null; then
        echo "✓ Set private key permissions to 600"
    else
        echo "⚠ Warning: Could not set permissions on some private keys (they may not exist)"
    fi
    
    if chmod 644 /etc/ssh/ssh_host_*.pub 2>/dev/null; then
        echo "✓ Set public key permissions to 644"
    else
        echo "⚠ Warning: Could not set permissions on some public keys (they may not exist)"
    fi
    
    # Fix SSH directory permissions
    if chmod 755 /etc/ssh; then
        echo "✓ Set SSH directory permissions to 755"
    else
        echo "✗ Failed to set SSH directory permissions"
    fi
    
    echo ""
    echo "Attempting to start SSH service..."
    
    # Start SSH service
    if systemctl start ssh.service; then
        echo "✓ SSH service started successfully"
    else
        echo "✗ Failed to start SSH service"
        echo "Checking if host keys need to be regenerated..."
        
        # Check if host keys exist
        if ! ls /etc/ssh/ssh_host_* >/dev/null 2>&1; then
            echo "No host keys found. Generating new host keys..."
            if ssh-keygen -A; then
                echo "✓ Host keys generated successfully"
                echo "Attempting to start SSH service again..."
                if systemctl start ssh.service; then
                    echo "✓ SSH service started successfully after key generation"
                else
                    echo "✗ SSH service still failed to start"
                fi
            else
                echo "✗ Failed to generate host keys"
            fi
        fi
    fi
    
    echo ""
    echo "Final SSH service status:"
    systemctl status ssh.service --no-pager
    
    echo ""
    echo "SSH service fix process completed."
    
else
    echo "SSH service fix skipped by user."
fi

echo ""
echo "=========================================="
echo "Script execution finished."