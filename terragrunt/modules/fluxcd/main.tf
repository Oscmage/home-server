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

# Install FluxCD
resource "null_resource" "install_fluxcd" {
  provisioner "local-exec" {
    command = <<EOT
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" << 'EOF'
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
        brew install fluxcd/tap/flux
        export GITHUB_TOKEN=${var.github_token}
        export GITHUB_USER=${var.github_user}
        flux check --pre
        flux bootstrap github --token-auth --owner=${var.github_user} --repository=${var.git_repository} --branch=main --path=${var.target_path} --personal --reconcile --private=false --force
      EOF
    EOT
  }
} 