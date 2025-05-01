#!/bin/bash

CLUSTER_NAME=$1

# Set up environment
export PATH="/usr/local/bin:$PATH"
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Start Docker Desktop
if ! open /Applications/Docker.app; then
    echo "Failed to start Docker Desktop. Please make sure it is installed and started manually."
    exit 1
fi


# check that k3d is installed
if ! command -v k3d &> /dev/null; then
    # Install k3d with Docker as container runtime
    echo "Installing k3d..."
    brew install k3d
else
    echo "k3d is already installed"
fi

# Check if cluster exists
if k3d cluster list | grep -q "$CLUSTER_NAME"; then
    echo "Cluster $CLUSTER_NAME already exists. Skipping creation."
else
    # create a cluster
    k3d cluster create "$CLUSTER_NAME" --image rancher/k3s:latest
fi

# install kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    brew install kubectl
else
    echo "kubectl is already installed"
fi

# Ensure PATH is updated after installations
export PATH="/usr/local/bin:$PATH"

# Wait for k3d to be ready
echo "Waiting for k3d to be ready..."
while ! kubectl get nodes; do
    sleep 1
done

echo "k3d installation complete!" 