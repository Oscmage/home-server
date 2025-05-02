To release a new application: 

1. Create a wrapper helm chart since we know helm is superior :)
2. Make sure that the namespace is already present, flux sadly requires it even if you can define it in your chart, that doesn't work.
3. Add a release in flux-helm-release