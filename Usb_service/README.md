# USB6 Fix - Permanent Solution for Boot Errors

**Version:** 1.0  
**Compatible with:** Ubuntu, Debian, and other systemd-based Linux distributions

## 🚨 Problem Description

This tool fixes the common USB6 boot error that appears as:
```
[XX.XXXXXX] usb usb6-port1: Cannot enable. Maybe the USB cable is bad?
```

This error typically occurs every 4-8 seconds during and after boot, flooding system logs and potentially causing boot delays or SSH service startup issues.

## ✨ Solution Overview

This automated installer provides a **permanent, one-time fix** that:
- Completely disables the problematic USB6 port
- Prevents the error from appearing on every boot
- Uses multiple redundant methods to ensure reliability
- Requires no manual intervention after installation

## 🔧 Installation

### Prerequisites
- Linux system with systemd
- Root/sudo access
- USB6 error currently occurring

### Quick Install
```bash
# Download the installer
wget https://raw.githubusercontent.com/your-repo/usb6-fix/main/install-usb6-fix.sh

# Make executable
chmod +x install-usb6-fix.sh

# Run as root (ONE TIME ONLY)
sudo ./install-usb6-fix.sh
```

### Alternative: Manual Download
1. Save the installer script as `install-usb6-fix.sh`
2. Make it executable: `chmod +x install-usb6-fix.sh`
3. Run with sudo: `sudo ./install-usb6-fix.sh`

## 📋 What Gets Installed

The installer creates several components for maximum reliability:

### 1. Udev Rules (`/etc/udev/rules.d/99-disable-usb6.rules`)
- Automatically disables USB6 when detected by the kernel
- Primary prevention method

### 2. Systemd Service (`/etc/systemd/system/disable-usb6.service`)
- Runs at boot to ensure USB6 is disabled
- Multiple disable methods for redundancy
- Automatic logging and error handling

### 3. Module Blacklist (`/etc/modprobe.d/blacklist-usb6.conf`)
- Prepared configuration for blocking USB modules if needed
- Currently commented out for safety

### 4. RC.local Backup Method
- Secondary safety measure using traditional init scripts
- Ensures fix works even if systemd fails

## 🔍 Verification

After installation and reboot:

### Check for USB6 Errors
```bash
# Should show no recent USB6 errors
dmesg | grep -i usb6
```

### Verify Service Status
```bash
# Should show "active (exited)" and "enabled"
sudo systemctl status disable-usb6.service
```

### View Service Logs
```bash
# Should show successful USB6 disable messages
sudo journalctl -u disable-usb6.service
```

## 🛠️ Management Commands

### Service Management
```bash
# Check service status
sudo systemctl status disable-usb6.service

# View detailed logs
sudo journalctl -u disable-usb6.service -f

# Manually run the fix
sudo systemctl start disable-usb6.service

# Restart the service
sudo systemctl restart disable-usb6.service
```

### Troubleshooting
```bash
# Check installation log
sudo cat /var/log/usb6-fix-install.log

# Reload udev rules manually
sudo udevadm control --reload-rules
sudo udevadm trigger

# Check if USB6 is currently present
ls -la /sys/bus/usb/devices/ | grep usb6
```

## 🗑️ Uninstallation

If you need to remove the fix (restore USB6 functionality):

```bash
# Disable and remove systemd service
sudo systemctl stop disable-usb6.service
sudo systemctl disable disable-usb6.service
sudo rm /etc/systemd/system/disable-usb6.service

# Remove udev rules
sudo rm /etc/udev/rules.d/99-disable-usb6.rules

# Remove module blacklist
sudo rm /etc/modprobe.d/blacklist-usb6.conf

# Clean up rc.local (manual edit required)
sudo nano /etc/rc.local  # Remove USB6 related lines

# Reload configurations
sudo systemctl daemon-reload
sudo udevadm control --reload-rules
```

## 🔧 Technical Details

### How It Works

1. **Udev Rules**: Immediately deauthorize USB6 when kernel detects it
2. **Systemd Service**: Run at boot to:
   - Deauthorize the USB6 device (`authorized="0"`)
   - Unbind from USB driver (`usb/unbind`)
   - Remove the device entirely (`remove="1"`)
3. **RC.local**: Backup method using traditional init scripts
4. **Module Blacklist**: Optional USB controller module blocking

### Supported Methods

The fix uses multiple methods simultaneously:
- **Device Deauthorization**: Prevents USB6 from being used
- **Driver Unbinding**: Removes USB6 from active driver management
- **Device Removal**: Completely removes USB6 from the system
- **Power Management**: Controls USB6 power states
- **Module Blocking**: Prevents problematic USB drivers from loading

### Safety Features

- **Non-destructive**: Only affects USB6, other USB ports remain functional
- **Reversible**: Complete uninstallation process provided
- **Logging**: All actions logged for troubleshooting
- **Backup**: Creates backup of existing configurations
- **Multiple Methods**: Redundancy ensures fix works even if one method fails

## 🐛 Troubleshooting

### Common Issues

**Issue: Service fails to start**
```bash
# Check service status and logs
sudo systemctl status disable-usb6.service
sudo journalctl -u disable-usb6.service

# Common fix: Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart disable-usb6.service
```

**Issue: USB6 errors still appear**
```bash
# Check if USB6 is actually disabled
ls -la /sys/bus/usb/devices/ | grep usb6

# Manually run the fix
sudo systemctl start disable-usb6.service

# Check udev rules are loaded
sudo udevadm control --reload-rules
```

**Issue: Other USB ports affected**
```bash
# This should not happen, but if it does:
# Check which USB devices are connected
lsusb

# Verify only USB6 is affected
ls -la /sys/bus/usb/devices/
```

### Getting Help

1. Check the installation log: `/var/log/usb6-fix-install.log`
2. Run service with verbose logging: `sudo journalctl -u disable-usb6.service -f`
3. Verify system compatibility: Ensure systemd is available
4. Test manual fix: Try the commands from the service manually

## 📝 Logs and Monitoring

### Important Log Files
- **Installation Log**: `/var/log/usb6-fix-install.log`
- **Service Logs**: `journalctl -u disable-usb6.service`
- **System Logs**: `/var/log/syslog` or `journalctl`
- **Udev Logs**: `udevadm monitor` (live monitoring)

### Monitoring USB6 Status
```bash
# Watch for USB6 messages in real-time
sudo dmesg -w | grep -i usb

# Check if USB6 exists in the system
find /sys -name "*usb6*" 2>/dev/null

# Monitor udev events
sudo udevadm monitor --subsystem-match=usb
```

## ⚠️ Important Notes

- **One-time installation**: Run the installer only once per system
- **Root required**: All commands must be run with sudo/root privileges
- **Reboot recommended**: Reboot after installation to test the complete fix
- **Backup created**: Original configurations are backed up automatically
- **Safe to use**: Only affects the problematic USB6 port
- **Persistent**: Fix survives system updates and kernel changes

## 📊 Compatibility

### Tested Systems
- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS  
- ✅ Debian 11 (Bullseye)
- ✅ Debian 12 (Bookworm)
- ✅ Other systemd-based distributions

### Requirements
- systemd init system
- udev device manager
- Bash shell
- Root/sudo access

## 📄 License

This project is provided as-is for fixing USB6 boot errors. Use at your own discretion.

## 🤝 Contributing

Found an issue or improvement? Please:
1. Check existing issues
2. Create detailed bug reports
3. Test thoroughly before submitting fixes
4. Follow the existing code style

---

**Remember**: This is a one-time fix. After successful installation and reboot, your USB6 errors should be permanently resolved! 🎉
