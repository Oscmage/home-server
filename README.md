# Home Server Setup

This repository contains the infrastructure as code and configuration for a Mac Mini M1 home server setup.

## Project Structure

- `/terragrunt`: Contains Terragrunt configurations for infrastructure management
- `/clusters`: Kubernetes (k3s) cluster configurations and manifests
- `/helm`: Helm charts for application deployments

## Overview

This setup includes:
- Mac Mini M1 running as a home server
- k3s for lightweight Kubernetes
- SSH access restricted to local network
- External access through Cloudflare Tunnel
- GitOps-style continuous deployment using FluxCD
- Helm charts for application management

## Prerequisites

- Mac Mini M1
- Local network access
- Cloudflare account
- Git repository for FluxCD

## Getting Started

[Documentation to be added as the setup progresses] 