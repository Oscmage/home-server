variable "target_host" {
  description = "The target host to install k3d on"
  type        = string
}

variable "target_user" {
  description = "The username to use for SSH connection"
  type        = string
}

variable "target_password" {
  description = "The password to use for SSH connection"
  type        = string
}

variable "target_ssh_port" {
  description = "The SSH port to use for connection"
  type        = number
  default     = 22
}

variable "k3d_version" {
  description = "The version of k3d to install"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster to create"
  type        = string
}

