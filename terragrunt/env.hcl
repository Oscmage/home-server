locals {
  # Read .env file using shell command with better error handling
  env_vars = {
    for line in split("\n", run_cmd("--terragrunt-quiet", "cat", "${get_parent_terragrunt_dir()}/../.env")) :
    trimspace(split("=", line)[0]) => trimspace(split("=", line)[1])
    if length(split("=", line)) == 2 && trimspace(split("=", line)[0]) != ""
  }

  # Set variables with validation and defaults
  target_host     = try(local.env_vars["TARGET_HOST"], error("TARGET_HOST is required in .env file"))
  target_user     = try(local.env_vars["TARGET_USER"], error("TARGET_USER is required in .env file"))
  target_password = try(local.env_vars["TARGET_PASSWORD"], error("TARGET_PASSWORD is required in .env file"))
  target_ssh_port = try(local.env_vars["TARGET_SSH_PORT"], "22")  # Default to 22 if not specified
  cluster_name    = try(local.env_vars["CLUSTER_NAME"], error("CLUSTER_NAME is required in .env file"))
  github_token    = try(local.env_vars["GITHUB_TOKEN"], error("GITHUB_TOKEN is required in .env file"))
  github_user     = try(local.env_vars["GITHUB_USER"], error("GITHUB_USER is required in .env file"))
  git_repository  = try(local.env_vars["GIT_REPOSITORY"], error("GIT_REPOSITORY is required in .env file"))
  git_branch      = try(local.env_vars["GIT_BRANCH"], "main")
  target_path     = try(local.env_vars["TARGET_PATH"], error("TARGET_PATH is required in .env file"))
} 