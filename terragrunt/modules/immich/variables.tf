variable "target_host" {
  description = "The target host to install k3d on"
  type        = string
}

variable "target_user" {
  description = "The username to use for SSH connection"
  type        = string
}

variable "target_private_key" {
  description = "The private key to use for SSH connection"
  type        = string
}

variable "target_ssh_port" {
  description = "The SSH port to use for connection"
  type        = number
  default     = 22
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  #sensitive   = true
}

variable "immich_version" {
  description = "The version of Immich to install"
  type        = string
  default     = "v1.132.3"
}

variable "cloudflare_tunnel_token" {
  description = "The token for the Cloudflare Tunnel"
  type        = string
  #sensitive   = true
}
