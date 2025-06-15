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

# Install Immich
resource "null_resource" "install_immich" {
  provisioner "local-exec" {
    command = <<EOT
      # Create immich directory
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" "mkdir -p /Users/oscarevertsson/immich"

      # Copy .env file
      cat > /tmp/immich.env << 'EOF'
      ${templatefile("${path.module}/scripts/example.env", {
        immich_version = var.immich_version
        db_password    = var.db_password
      })}
      EOF
      scp -i "${var.target_private_key}" -P ${var.target_ssh_port} /tmp/immich.env "${var.target_user}@${var.target_host}:/Users/oscarevertsson/immich/.env"
      rm -f /tmp/immich.env

      # Copy docker-compose.yml
      scp -i "${var.target_private_key}" -P ${var.target_ssh_port} "${path.module}/scripts/docker-compose.yml" "${var.target_user}@${var.target_host}:/Users/oscarevertsson/immich/docker-compose.yml"

      # Start the containers
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" << 'EOF'
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
        cd /Users/oscarevertsson/immich
        docker-compose up -d
      EOF
    EOT
  }
}

# Install Cloudflare Tunnel
resource "null_resource" "start_cloudflare_tunnel" {
  provisioner "local-exec" {
    command = <<EOT
      ssh -i "${var.target_private_key}" -p ${var.target_ssh_port} "${var.target_user}@${var.target_host}" << 'EOF'
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
        brew install cloudflared
        echo ${var.cloudflare_tunnel_token} | sudo -S cloudflared service install ${var.cloudflare_tunnel_token}
      EOF
    EOT
  }
} 