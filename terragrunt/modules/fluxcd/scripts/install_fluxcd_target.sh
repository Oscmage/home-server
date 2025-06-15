#!/bin/bash

# Exit on any error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if flux is installed
is_flux_installed() {
    command_exists flux
    return $?
}

# Function to check flux status
check_flux_status() {
    echo "Checking flux status..."
    flux check
}

# Debug: Print environment variables (without showing full token)
echo "Environment check:"
echo "GITHUB_USER: ${GITHUB_USER}"
echo "GIT_REPO: ${GIT_REPO}"
echo "TARGET_PATH: ${TARGET_PATH}"
echo "GITHUB_TOKEN exists: $(if [ -n "${GITHUB_TOKEN}" ]; then echo "yes"; else echo "no"; fi)"

# Install Flux CLI
if ! is_flux_installed; then
    echo "Installing Flux CLI..."
    curl -s https://fluxcd.io/install.sh | sudo bash
    
    # Verify installation
    if ! is_flux_installed; then
        echo "Failed to install Flux CLI"
        exit 1
    fi
    
    echo "Flux CLI installation completed successfully"
else
    echo "Flux CLI is already installed"
fi

# Bootstrap Flux
echo "Bootstrapping Flux..."
echo "GITHUB_TOKEN: ${GITHUB_TOKEN}"
export GITHUB_TOKEN="${GITHUB_TOKEN}"
export GITHUB_USER=${GITHUB_USER}

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
# Bootstrap the repository
echo "Bootstrapping repository..."
if ! flux bootstrap github \
    --token-auth \
    --owner=${GITHUB_USER} \
    --repository=${GIT_REPO} \
    --branch=main \
    --path=${TARGET_PATH} \
    --personal \
    --reconcile \
    --private=false \
    --force \
    --token=${GITHUB_TOKEN}; then
    echo "Failed to bootstrap Flux"
    exit 1
fi

echo "Flux bootstrap completed successfully" 