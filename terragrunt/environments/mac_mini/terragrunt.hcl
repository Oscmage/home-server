locals {
  # Read environment variables
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Configure Terragrunt to automatically store tfstate files in a local directory
remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/../../state/${path_relative_to_include()}/terraform.tfstate"
  }
}

# Configure root level variables that all resources can inherit
inputs = {
  target_host     = local.vars.locals.target_host
  target_user     = local.vars.locals.target_user
  target_ssh_port = local.vars.locals.target_ssh_port
  cluster_name    = local.vars.locals.cluster_name
} 