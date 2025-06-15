#!/bin/bash

CLUSTER_NAME=$1

# Set up environment
export PATH="/usr/local/bin:$PATH"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if k3s is installed
if ! command_exists k3s; then
    echo "Installing k3s..."
    # Install k3s without requiring sudo
    curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -
    
    # Create symlink for kubectl
    if [ ! -f /usr/local/bin/kubectl ]; then
        sudo ln -s /usr/local/bin/k3s /usr/local/bin/kubectl
    fi
else
    echo "k3s is already installed"
fi

# Ensure k3s service is running
if ! systemctl is-active --quiet k3s; then
    echo "Starting k3s service..."
    sudo systemctl start k3s
fi

# Wait for k3s to be ready
echo "Waiting for k3s to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if command_exists kubectl && kubectl get nodes >/dev/null 2>&1; then
        break
    fi
    echo "Waiting for k3s to be ready... (attempt $((attempt + 1))/$max_attempts)"
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -eq $max_attempts ]; then
    echo "Error: k3s failed to start within the timeout period"
    exit 1
fi

# Get the kubeconfig
echo "Setting up kubeconfig..."
mkdir -p ~/.kube
sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
chmod 600 ~/.kube/config

echo "k3s installation complete!" 