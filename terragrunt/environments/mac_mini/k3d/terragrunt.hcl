include "root" {
  path = find_in_parent_folders()
}

locals {
  # Read environment variables
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/k3d"
}

inputs = {
  target_host     = local.vars.locals.target_host
  target_user     = local.vars.locals.target_user
  target_password = local.vars.locals.target_password
  target_ssh_port = local.vars.locals.target_ssh_port
  cluster_name    = local.vars.locals.cluster_name
} 