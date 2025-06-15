variable "target_host" {
  description = "The target host to install k3d on"
  type        = string
}

variable "target_user" {
  description = "The username to use for SSH connection"
  type        = string
}

variable "target_ssh_port" {
  description = "The SSH port to use for connection"
  type        = number
  default     = 22
}

variable "target_private_key" {
  description = "The private key to use for SSH connection"
  type        = string
}
