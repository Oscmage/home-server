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

# Install Immich
resource "null_resource" "install_immich" {
  # Establish SSH connection
  connection {
    type     = local.ssh_connection.type
    user     = local.ssh_connection.user
    host     = local.ssh_connection.host
    port     = local.ssh_connection.port
    password = local.ssh_connection.password
  }

  # Create immich directory if it doesn't exist
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /Users/oscarevertsson/immich"
    ]
  }

  provisioner "file" {
    content     = templatefile("${path.module}/scripts/example.env", {
      immich_version = var.immich_version
      db_password    = var.db_password
    })
    destination = "/Users/oscarevertsson/immich/.env"
  }

  provisioner "file" {
    source      = "scripts/docker-compose.yml"
    destination = "/Users/oscarevertsson/immich/docker-compose.yml"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=\"/opt/homebrew/bin:/usr/local/bin:$PATH\"",
      "ls -la", # for debugging
      "cd immich",
      "docker-compose up -d"
    ]
  }
}

# Install Immich
resource "null_resource" "start_cloudflare_tunnel" {
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
      "brew install cloudflared", 
      "echo ${local.ssh_connection.password} | sudo -S cloudflared service install ${var.cloudflare_tunnel_token}"
    ]
  }
} 