#!/bin/bash

CLUSTER_NAME=$1

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if k3s is running
is_k3s_running() {
    systemctl is-active --quiet k3s
    return $?
}

# Function to check k3s service status
check_k3s_status() {
    echo "Checking k3s service status..."
    systemctl status k3s.service
    journalctl -xeu k3s.service --no-pager
}

# Function to start k3s
start_k3s() {
    echo "Starting k3s service..."
    
    # First, try to stop any existing failed service
    if systemctl is-failed k3s.service >/dev/null 2>&1; then
        echo "Found failed k3s service. Attempting to reset..."
        systemctl reset-failed k3s.service
        systemctl stop k3s.service
    fi
    
    # Start the service
    if ! systemctl start k3s.service; then
        echo "Failed to start k3s service. Checking status..."
        check_k3s_status
        return 1
    fi
    
    # Wait a moment for the service to initialize
    sleep 5
    
    # Check if the service is actually running
    if ! systemctl is-active --quiet k3s.service; then
        echo "k3s service failed to start properly. Checking status..."
        check_k3s_status
        return 1
    fi
    
    return 0
}

# Function to wait for k3s to be ready
wait_for_k3s() {
    echo "Waiting for k3s to be ready..."
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if k3s kubectl get nodes >/dev/null 2>&1; then
            echo "k3s is ready!"
            return 0
        fi
        echo "Attempt $attempt/$max_attempts: Waiting for k3s to be ready..."
        sleep 5
        attempt=$((attempt + 1))
    done
    
    echo "Error: k3s failed to start within the expected time"
    check_k3s_status
    return 1
}

# Function to verify cluster creation
verify_cluster() {
    echo "Verifying cluster creation..."
    if k3s kubectl get nodes | grep -q "Ready"; then
        echo "Cluster is ready and nodes are in Ready state"
        return 0
    else
        echo "Error: Cluster verification failed"
        check_k3s_status
        return 1
    fi
}

# Check if k3s is installed
if ! command_exists k3s; then
    echo "Installing k3s..."
    # Install k3s without cluster configuration initially
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -
    
    # Wait for k3s to be ready
    if ! wait_for_k3s; then
        echo "Failed to start k3s"
        exit 1
    fi
    
    # Verify cluster creation
    if ! verify_cluster; then
        echo "Failed to verify cluster creation"
        exit 1
    fi
    
    echo "k3s installation and cluster creation completed successfully"
else
    echo "k3s is already installed"
    
    # Check if k3s is running, if not start it
    if ! is_k3s_running; then
        echo "k3s is not running. Starting k3s..."
        if ! start_k3s; then
            echo "Failed to start k3s service"
            exit 1
        fi
    else
        echo "k3s service is already running"
    fi
    
    # Verify if the existing cluster is running
    if ! wait_for_k3s; then
        echo "Existing k3s cluster is not running properly"
        exit 1
    fi
    
    # Verify cluster state
    if ! verify_cluster; then
        echo "Existing cluster is not in a healthy state"
        exit 1
    fi
    
    echo "Existing k3s cluster is running properly"
fi