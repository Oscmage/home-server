# Home Server Setup

This repository contains the infrastructure as code and configuration for a Linx server setup. This has only been tested with a Linux Server 24 LTS.

## Is this overkill?

100%, this is mostly for learning and fun.

## Project Structure

- `/terragrunt`: Contains Terragrunt configurations for infrastructure management
- `/helm`: Helm charts for application deployments

## Overview

This setup includes:
- Linux Server running as a home server
- k3s for lightweight Kubernetes
- SSH access restricted to local network
- External access through Cloudflare Tunnel
- GitOps-style continuous deployment using FluxCD
- Helm charts for application management

## Prerequisites

- Mac target host (tested on mac mini)
- Local network access
- Cloudflare account
- Git repository for FluxCD
- Terragrunt installed

### Mac (Server) Prerequisites

1. Enable remote login over local network. Take note of the address of the machine. Make sure that you create a user with admin privilegies.
2. Make sure you have `docker` and `brew` installed on the Mac.

## Getting Started

1. Rename/copy the `.env.template` file to `.env` and update the values.
2. We are now going to make sure to create the cluster (which will be running k3s), and install fluxcd this is done through terragrunt. Run `terragrunt run-all apply` in `/terragrunt/environments/mac_mini`