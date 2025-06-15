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
  }
}

output "ssh_target_debug" {
  value = var.target_host
}


# Install docker
resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    command = <<EOT
      # Define variables for reuse
      REMOTE_SCRIPT="/tmp/install_docker_target.sh"
      LOCAL_SCRIPT="scripts/install_docker_target.sh"

      # Step 1: Upload the script to the target host
      scp -i "${var.target_private_key}" "$LOCAL_SCRIPT" "${var.target_user}@${var.target_host}:$REMOTE_SCRIPT"

      # Step 2: Make the script executable and run it
      ssh -i "${var.target_private_key}" "${var.target_user}@${var.target_host}" "chmod +x $REMOTE_SCRIPT && $REMOTE_SCRIPT"

      # Step 3: Clean up the script after execution
      ssh -i "${var.target_private_key}" "${var.target_user}@${var.target_host}" "rm -f $REMOTE_SCRIPT"
    EOT
  }
}