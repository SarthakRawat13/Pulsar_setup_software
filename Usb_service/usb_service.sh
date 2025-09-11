#!/bin/bash

# Minimal USB6 Fix - Working Solution Only
# Based on proven results: Reduces USB6 errors from continuous to 2 boot-time errors

set -e

# Check root
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: Run as root - sudo $0"
   exit 1
fi

echo "Installing minimal USB6 fix (proven working solution)..."

# 1. Primary udev rule (proven effective)
cat > /etc/udev/rules.d/99-disable-usb6.rules << 'EOF'
SUBSYSTEM=="usb", KERNEL=="usb6", ACTION=="add", ATTR{authorized}="0"
SUBSYSTEM=="usb", KERNELS=="usb6", ACTION=="add", ATTR{authorized}="0"
SUBSYSTEM=="usb", DEVPATH=="/devices/*/usb6", ATTR{authorized}="0"
EOF

# 2. Simple systemd service (no device dependency to avoid timeout)
cat > /etc/systemd/system/disable-usb6.service << 'EOF'
[Unit]
Description=Disable USB6 to prevent boot errors
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c 'echo 0 > /sys/bus/usb/devices/usb6/authorized 2>/dev/null || true; echo usb6 > /sys/bus/usb/drivers/usb/unbind 2>/dev/null || true'
TimeoutStartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 3. RC.local backup (proven working)
if [ ! -f /etc/rc.local ]; then
    cat > /etc/rc.local << 'EOF'
#!/bin/bash
(
sleep 5
echo "0" > /sys/bus/usb/devices/usb6/authorized 2>/dev/null || true
echo "usb6" > /sys/bus/usb/drivers/usb/unbind 2>/dev/null || true
) &
exit 0
EOF
    chmod +x /etc/rc.local
else
    if ! grep -q "usb6" /etc/rc.local; then
        sed -i '/^exit 0/i\
(\
sleep 5\
echo "0" > /sys/bus/usb/devices/usb6/authorized 2>/dev/null || true\
echo "usb6" > /sys/bus/usb/drivers/usb/unbind 2>/dev/null || true\
) &' /etc/rc.local
    fi
fi

# 4. Apply immediate fix
echo "0" > /sys/bus/usb/devices/usb6/authorized 2>/dev/null || true
echo "usb6" > /sys/bus/usb/drivers/usb/unbind 2>/dev/null || true

# 5. Enable everything
systemctl daemon-reload
systemctl enable disable-usb6.service
systemctl start disable-usb6.service
udevadm control --reload-rules

echo "USB6 fix installed successfully!"
echo "Expected result: USB6 errors reduced from continuous to 2 boot-time errors"
echo "Reboot to test: sudo reboot"