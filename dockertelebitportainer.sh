#!/bin/bash

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Update package list
apt update

# Install dependencies
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Test installations
docker --version
docker-compose --version
docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Add a non-root user to the docker group (optional)
read -p "Do you want to add a non-root user to the docker group? (y/n): " add_user
if [ "$add_user" = "y" ]; then
    read -p "Enter the username: " username
    usermod -aG docker $username
    echo "User $username added to the docker group. Please log out and back in to apply the changes."
fi

# Install Telebit.io
curl https://get.telebit.io/ | bash

# Reboot the server
read -p "Do you want to reboot the server now? (y/n): " reboot_server
if [ "$reboot_server" = "y" ]; then
    echo "Rebooting the server..."
    reboot
else
    echo "Please remember to reboot your server to apply changes."
fi

exit 0
