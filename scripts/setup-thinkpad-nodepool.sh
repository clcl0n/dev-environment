#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Comment out swap entry in fstab
sed -i '/ swap / s/^/#/' /etc/fstab

# Disable swap immediately
swapoff -a

# Configure lid switch behavior (keep laptop running when lid is closed)
LOGIND_CONF="/etc/systemd/logind.conf"

# Uncomment and set HandleLidSwitch=ignore
sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' "$LOGIND_CONF"
sed -i 's/^HandleLidSwitch=.*/HandleLidSwitch=ignore/' "$LOGIND_CONF"

# Uncomment and set LidSwitchIgnoreInhibited=no
sed -i 's/^#LidSwitchIgnoreInhibited=.*/LidSwitchIgnoreInhibited=no/' "$LOGIND_CONF"
sed -i 's/^LidSwitchIgnoreInhibited=.*/LidSwitchIgnoreInhibited=no/' "$LOGIND_CONF"

# Restart logind to apply changes
systemctl restart systemd-logind

# Create bridge configuration file
BRIDGE_FILE="/etc/netplan/50-bridge.yaml"

cat > "$BRIDGE_FILE" << 'EOF'
network:
  bridges:
    br0:
      interfaces:
        - enp2s0f0
      dhcp4: true
      parameters:
        stp: false
        forward-delay: 0
EOF

# Set correct permissions for netplan file
chmod 600 "$BRIDGE_FILE"

# Apply netplan configuration
netplan apply

# Install dependencies
snap install multipass