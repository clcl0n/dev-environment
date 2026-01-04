#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Install dependencies
sudo -u "$SUDO_USER" brew install --cask multipass