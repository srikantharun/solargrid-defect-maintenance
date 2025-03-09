# Setting up Rancher for K3s Management

This guide will help you install Rancher to manage your K3s clusters.

## Prerequisites
- Docker installed on your management server
- Internet connectivity
- Minimum 4GB RAM on the management server

## Install Rancher using Docker

```bash
# Install Rancher using Docker
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest
```

## Access Rancher UI

1. Open a browser and navigate to `https://<YOUR_SERVER_IP>`
2. Set up admin password when prompted
3. Create a new cluster or import existing one

## Import Your K3s Cluster

1. In Rancher UI, click "Add Cluster"
2. Select "Import Existing" option
3. Name your cluster (e.g., "solar-farm-k3s")
4. Click "Create"
5. Rancher will provide a kubectl command to run on your K3s master node
6. Run the provided command on your K3s master node
7. Wait for the cluster to be imported (usually takes about 1-2 minutes)

## Deploy Solar Farm Application

There are two ways to deploy your application:

### Option 1: Using Rancher UI
1. Navigate to your imported cluster
2. Go to "Workloads" and use "Import YAML" to import your manifests

### Option 2: Using ArgoCD (Recommended)
1. Install ArgoCD on your K3s cluster:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```
2. Apply your ArgoCD application manifests:
   ```bash
   kubectl apply -f argocd/projects/solargrid-project.yaml
   kubectl apply -f argocd/applications/solargrid-app.yaml
   ```

## Verification

1. Verify all components are running:
   ```bash
   kubectl get pods -n solar-panel-detection
   ```

2. Access the API using NodePort:
   ```bash
   curl http://<ANY_NODE_IP>:30080/api/health
   ```

## Monitoring with Rancher

1. In Rancher UI, navigate to your cluster
2. Check the "Monitoring" tab for resource usage
3. For Prometheus/Grafana integration, use the built-in monitoring apps in Rancher Apps & Marketplace
