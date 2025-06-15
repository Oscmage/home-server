include "root" {
  path = find_in_parent_folders()
}

locals {
  # Read environment variables
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/docker"
}

inputs = {
  target_host     = local.vars.locals.target_host
  target_user     = local.vars.locals.target_user
  target_private_key = local.vars.locals.target_private_key
  target_ssh_port = local.vars.locals.target_ssh_port
} 