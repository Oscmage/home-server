#!/bin/bash

# Check if required arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <k3d_version> <password>"
    echo "Example: $0 v1.27.4+k3d1 mypassword"
    exit 1
fi

K3D_VERSION=$1
PASSWORD=$2
CLUSTER_NAME=$3

# Function to run sudo commands with password
run_sudo() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Set up environment
export PATH="/usr/local/bin:$PATH"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

# Start Docker Desktop
if ! open /Applications/Docker.app; then
    echo "Failed to start Docker Desktop. Please make sure it is installed and started manually."
    exit 1
fi

# Install k3d with Docker as container runtime
echo "Installing k3d version $K3D_VERSION..."
run_sudo curl -sfL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.0.0 bash

# check that k3d is installed
if ! command -v k3d &> /dev/null; then
    echo "k3d is not installed. Exiting."
    exit 1
fi

# create a cluster
k3d cluster create "$CLUSTER_NAME"

# install kubectl
run_sudo brew install kubectl

# Ensure PATH is updated after installations
export PATH="/usr/local/bin:$PATH"

# Wait for k3d to be ready
echo "Waiting for k3d to be ready..."
while ! kubectl get nodes; do
    sleep 1
done

echo "k3d installation complete!" 