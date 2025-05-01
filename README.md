# Home Server Setup

This repository contains the infrastructure as code and configuration for a Mac home server setup. This has only been tested with a Mac Mini M1 (2020)

## Project Structure

- `/terragrunt`: Contains Terragrunt configurations for infrastructure management
- `/clusters`: Kubernetes (k3d) cluster configurations and manifests
- `/helm`: Helm charts for application deployments

## Overview

This setup includes:
- Mac Mini M1 running as a home server
- k3d for lightweight Kubernetes
- SSH access restricted to local network
- External access through Cloudflare Tunnel
- GitOps-style continuous deployment using FluxCD
- Helm charts for application management

## Prerequisites

- Mac target host (tested on mac mini)
- Local network access
- Cloudflare account
- Git repository for FluxCD

### Mac Mini

1. Enable remote login over local network. Take note of the address of the machine.
2. Make sure you have `docker` and `brew` installed on the Mac.
3. 

## Getting Started

[Documentation to be added as the setup progresses] 