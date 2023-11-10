#!/bin/bash

# Download ProtonVPN package
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
dpkg -i protonvpn-stable-release_1.0.3-2_all.deb

# Update package list
apt-get update

# Install ProtonVPN for GNOME Desktop
apt-get install proton-vpn-gnome-desktop

# Install necessary dependencies
#apt-get install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator

# Install Tailscale using the installation script
curl -fsSL https://tailscale.com/install.sh | sh

# Enable IP forwarding for Tailscale
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf
