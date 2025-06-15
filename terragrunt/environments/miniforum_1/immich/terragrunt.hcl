include "root" {
  path = find_in_parent_folders()
}

locals {
  # Read environment variables
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/immich"
}

dependencies {
  paths = ["../k3s"]
}

inputs = {
  target_host     = local.vars.locals.target_host
  target_user     = local.vars.locals.target_user
  target_private_key = local.vars.locals.target_private_key
  target_ssh_port = local.vars.locals.target_ssh_port
  db_password    = local.vars.locals.db_password
  immich_version = local.vars.locals.immich_version
  cloudflare_tunnel_token = local.vars.locals.cloudflare_tunnel_token
} 