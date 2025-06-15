variable "target_host" {
  description = "The target host to install k3s on"
  type        = string
}

variable "target_user" {
  description = "The user to use for SSH connection"
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

variable "cluster_name" {
  description = "The name of the k3s cluster"
  type        = string
}

variable "target_sudo_password" {
  description = "The sudo password for the target user"
  type        = string
}

