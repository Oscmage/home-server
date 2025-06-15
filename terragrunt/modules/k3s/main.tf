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

# Install k3s
resource "null_resource" "install_k3s" {
  provisioner "local-exec" {
    command = <<EOT
      # Define variables for reuse
      REMOTE_SCRIPT="/tmp/install_k3s_target.sh"
      LOCAL_SCRIPT="${path.module}/scripts/install_k3s_target.sh"

      # Step 1: Upload the script to the target host
      scp -i "${var.target_private_key}" -P ${var.target_ssh_port} "$LOCAL_SCRIPT" "${var.target_user}@${var.target_host}:$REMOTE_SCRIPT"

      # Step 2: Make the script executable and run it with sudo password
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" "chmod +x $REMOTE_SCRIPT && echo '${var.target_sudo_password}' | sudo -S $REMOTE_SCRIPT ${var.cluster_name}"

      # Step 3: Clean up the script after execution
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" "rm -f $REMOTE_SCRIPT"
    EOT
  }
} 