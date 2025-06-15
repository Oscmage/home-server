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

variable "git_repository" {
  description = "Git repository URL"
  type        = string
}

variable "git_branch" {
  description = "Git branch to use"
  type        = string
  default     = "main"
}

variable "target_path" {
  description = "Path within the Git repository to store the Flux manifests"
  type        = string
} 

variable "github_token" {
  description = "GitHub token"
  type        = string
}

variable "github_user" {
  description = "GitHub user"
  type        = string
}