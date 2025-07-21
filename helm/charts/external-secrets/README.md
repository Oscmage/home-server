

## Installation
1. 
Before applying you need to get access to the caBundle, this you can do by running 

```bash
kubectl get secret bitwarden-tls-certs -n external-secrets -o jsonpath='{.data.ca\.crt}'
```

Note that this is not something you want to commit to the repository!

2. You also need to add the machine token which is done through creating a kubernetes secret ironically.

 kubectl -n external-secrets create secret generic bitwarden-access-token \
  --from-literal=token="<MACHINE TOKEN HERE>"


## Usage

### Single secret
```bash
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: test
spec:
  refreshInterval: 1h
  secretStoreRef:
    # This name must match the metadata.name in the `SecretStore`
    name: {{ .Values.secretStore.name }}
    kind: SecretStore
  data:
  - secretKey: test
    remoteRef:
      key: "f909240a-a550-44ae-8dda-b321014c2283"

```

### Multiple secrets from valid json

```bash
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: test
spec:
  refreshInterval: 1h
  secretStoreRef:
    # This name must match the metadata.name in the `SecretStore`
    name: {{ .Values.secretStore.name }}
    kind: SecretStore
  target:
    name: multiple-test  # name of the k8s Secret to be created
    creationPolicy: Owner
  dataFrom:
  - extract:
      key: "346d2f02-92f0-479c-9181-b321014df1ef"  # name of the GCPSM secret
```