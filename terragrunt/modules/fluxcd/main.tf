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
    password = var.target_password
  }
}

# Install FluxCD
resource "null_resource" "install_fluxcd" {
  # Establish SSH connection
  connection {
    type     = local.ssh_connection.type
    user     = local.ssh_connection.user
    host     = local.ssh_connection.host
    port     = local.ssh_connection.port
    password = local.ssh_connection.password
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=\"/opt/homebrew/bin:/usr/local/bin:$PATH\"",
      "brew install fluxcd/tap/flux",
      "export GITHUB_TOKEN=${var.github_token}",
      "export GITHUB_USER=${var.github_user}",
      "flux check --pre",
      "flux bootstrap github --token-auth --owner=${var.github_user} --repository=${var.git_repository} --branch=main --path=${var.target_path} --personal --reconcile --private=false --force"
    ]
  }
} 