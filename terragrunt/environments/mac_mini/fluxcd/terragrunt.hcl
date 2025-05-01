include "root" {
  path = find_in_parent_folders()
}

locals {
  # Read environment variables
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/fluxcd"
}

dependencies {
  paths = ["../k3d"]
}

inputs = {
  target_host     = local.vars.locals.target_host
  target_user     = local.vars.locals.target_user
  target_password = local.vars.locals.target_password
  target_ssh_port = local.vars.locals.target_ssh_port
  git_repository = local.vars.locals.git_repository
  git_branch     = local.vars.locals.git_branch
  target_path    = local.vars.locals.target_path
  github_token   = local.vars.locals.github_token
  github_user    = local.vars.locals.github_user
} 