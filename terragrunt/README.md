# Terragrunt Configuration

This directory contains the Terragrunt configuration for setting up the home server infrastructure.

## Structure

- `terragrunt.hcl`: Main Terragrunt configuration
- `env.hcl`: Environment variables configuration
- `k3d/`: k3d installation module
  - `main.tf`: Main Terraform configuration
  - `variables.tf`: Variable definitions
  - `terragrunt.hcl`: Module-specific Terragrunt configuration

## Usage

1. Create a `.env` file in the root directory with the following variables:
   ```
   TARGET_HOST=your_target_ip
   TARGET_USER=your_username
   TARGET_SSH_PORT=22
   k3d_VERSION=v1.28.5+k3d1
   ```

2. Place your SSH private key in the root directory as `id_rsa`

3. Run Terragrunt:
   ```bash
   cd terragrunt/k3d
   terragrunt apply
   ```

## State Management

The Terraform state is stored locally in the `terragrunt_state` directory. This directory is ignored by git to prevent committing sensitive state information. 