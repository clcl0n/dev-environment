#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

apt-get update
apt-get install -y nginx nginx-extras

sudo ip link set wlan0 down