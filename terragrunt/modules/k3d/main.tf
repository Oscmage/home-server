terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

# SSH connection configuration
locals {
  ssh_connection = {
    type     = "ssh"
    user     = var.target_user
    host     = var.target_host
    port     = var.target_ssh_port
    password = var.target_password
  }
}


# Install k3d
resource "null_resource" "install_k3d" {
  # Establish SSH connection
  connection {
    type     = local.ssh_connection.type
    user     = local.ssh_connection.user
    host     = local.ssh_connection.host
    port     = local.ssh_connection.port
    password = local.ssh_connection.password
  }

  provisioner "file" {
    source      = "scripts/install_k3d_target.sh"
    destination = "/tmp/install_k3d_target.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k3d_target.sh",
      "if ! /tmp/install_k3d_target.sh ${var.target_password} ${var.cluster_name}; then",
      "  echo 'Script failed with exit code $?'",
      "  exit 1",
      "fi",
      "rm -f /tmp/install_k3d_target.sh"
    ]
  }
} 