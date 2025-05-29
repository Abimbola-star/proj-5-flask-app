#!/bin/bash

# Setup logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting Jenkins user data script execution at $(date)"

# Basic system setup
echo "Updating system packages..."
yum update -y || echo "Yum update failed but continuing"
echo "Installing docker and git..."
amazon-linux-extras install -y docker || echo "Failed to install docker from amazon-linux-extras"
yum install -y git || echo "Failed to install git"

# Enable and start Docker
echo "Enabling and starting Docker..."
systemctl enable docker
systemctl start docker || echo "Failed to start Docker"

# Add ec2-user to docker group
echo "Adding ec2-user to docker group..."
usermod -aG docker ec2-user

# Run Jenkins container
echo "Starting Jenkins container..."
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts || echo "Failed to start Jenkins container"

echo "User data script completed at $(date)"