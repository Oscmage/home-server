variable "target_host" {
  description = "The target host to install FluxCD on"
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

variable "target_sudo_password" {
  description = "The sudo password for the target user"
  type        = string
}

variable "git_repository" {
  description = "Git repository name for FluxCD"
  type        = string
}

variable "git_branch" {
  description = "Git branch to use"
  type        = string
  default     = "main"
}

variable "target_path" {
  description = "Path in the git repository where FluxCD will store its manifests"
  type        = string
}

variable "github_token" {
  description = "GitHub token for FluxCD"
  type        = string
}

variable "github_user" {
  description = "GitHub username for FluxCD"
  type        = string
}