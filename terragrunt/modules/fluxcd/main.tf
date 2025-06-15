terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
  backend "local" {}
}

# SSH connection configuration
locals {
  ssh_connection = {
    type     = "ssh"
    user     = var.target_user
    host     = var.target_host
    port     = var.target_ssh_port
    private_key = var.target_private_key
    sudo_password = var.target_sudo_password
  }
}

# Install FluxCD
resource "null_resource" "install_fluxcd" {
  provisioner "local-exec" {
    command = <<EOT
      # Define variables for reuse
      REMOTE_SCRIPT="/tmp/install_fluxcd_target.sh"
      LOCAL_SCRIPT="${path.module}/scripts/install_fluxcd_target.sh"

      # Step 1: Upload the script to the target host
      scp -i "${var.target_private_key}" -P ${var.target_ssh_port} "$LOCAL_SCRIPT" "${var.target_user}@${var.target_host}:$REMOTE_SCRIPT"
      echo "Script uploaded to target host"

      # Step 2: Make the script executable and run it with sudo password
      if ! ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" "chmod +x $REMOTE_SCRIPT && echo '${var.target_sudo_password}' | sudo -S -E KUBECONFIG='$HOME/.kube/config' GITHUB_TOKEN='${var.github_token}' GITHUB_USER='${var.github_user}' GIT_REPO='${var.git_repository}' TARGET_PATH='${var.target_path}' $REMOTE_SCRIPT"; then
        echo "FluxCD installation failed"
        exit 1
      fi

      # Step 3: Clean up the script after execution
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" "rm -f $REMOTE_SCRIPT"
    EOT
  }
} 