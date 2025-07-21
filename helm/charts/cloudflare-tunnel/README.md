# Cloudflare Tunnel Chart

A simple, reusable Helm chart for deploying Cloudflare Tunnel with external secrets integration.

## Overview

This chart deploys a Cloudflare Tunnel using the `cloudflare/cloudflared` image and integrates with External Secrets Operator to securely manage tunnel tokens from Bitwarden.

## Features

- Simple configuration with only 2 required parameters
- External secrets integration for secure token management
- Health checks with liveness probe
- 2 replicas for high availability
- Hardcoded best practices for production use

## Prerequisites

- Kubernetes cluster with External Secrets Operator installed
- Bitwarden secret store configured in the cluster
- Cloudflare tunnel token stored in Bitwarden

## Installation

### Basic Installation

```bash
helm install my-tunnel ./cloudflare-tunnel \
  --set namespace="my-namespace" \
  --set bitwardenTokenRef="your-bitwarden-item-id"
```

### Using as a Dependency

Add this chart as a dependency to your application chart:

```yaml
# Chart.yaml
dependencies:
  - name: cloudflare-tunnel
    version: 0.1.0
    repository: file://../cloudflare-tunnel
```

Then configure it in your values.yaml:

```yaml
# values.yaml
cloudflare-tunnel:
  namespace: "my-namespace"
  bitwardenTokenRef: "your-bitwarden-item-id"
```

## Configuration

| Parameter | Description | Required |
|-----------|-------------|----------|
| `namespace` | Namespace where the tunnel will be deployed | Yes |
| `bitwardenTokenRef` | Bitwarden item ID for the tunnel token | Yes |

## Usage Examples

### Registry Application

```yaml
# values.yaml for registry
cloudflare-tunnel:
  namespace: registry
  bitwardenTokenRef: "90d6aad7-99f8-4907-b839-b3210151aa8c"
```

### Immich Application

```yaml
# values.yaml for immich
cloudflare-tunnel:
  namespace: immich
  bitwardenTokenRef: "your-immich-tunnel-token-id"
```

### Equilink Application

```yaml
# values.yaml for equilink
cloudflare-tunnel:
  namespace: equilink
  bitwardenTokenRef: "your-equilink-tunnel-token-id"
```

## What Gets Deployed

- **Deployment**: 2 replicas of cloudflare/cloudflared:latest
- **ExternalSecret**: Fetches tunnel token from Bitwarden
- **Health Checks**: Liveness probe on /ready endpoint
- **Security**: ICMP traffic enabled for ping/traceroute

## Security

- Tunnel tokens are stored securely in Bitwarden
- External Secrets Operator handles token retrieval
- No sensitive data is stored in Helm values
- Standard security context with minimal permissions

## Troubleshooting

### Check Tunnel Status

```bash
kubectl get pods -n <namespace> -l app.kubernetes.io/name=cloudflare-tunnel
kubectl logs -n <namespace> -l app.kubernetes.io/name=cloudflare-tunnel
```

### Check External Secret

```bash
kubectl get externalsecret -n <namespace>
kubectl describe externalsecret <tunnel-name>-secret -n <namespace>
```

### Verify Secret Store

```bash
kubectl get secretstore -A
kubectl describe secretstore bitwarden-secret-store
``` 