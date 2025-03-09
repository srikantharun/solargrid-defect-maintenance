# Solar Farm Defect Detection System for Azure Kubernetes Service (AKS)

This repository contains Kubernetes manifests for deploying a solar panel defect detection system on Azure Kubernetes Service (AKS).

## Prerequisites

1. An active Azure subscription
2. The Azure CLI installed and configured
3. kubectl installed and configured
4. Helm installed (optional, for monitoring components)

## AKS Cluster Setup

1. Create a resource group for your AKS cluster:

```bash
az group create --name solar-defect-detection-rg --location eastus
```

2. Create an AKS cluster:

```bash
az aks create \
    --resource-group solar-defect-detection-rg \
    --name solar-defect-cluster \
    --node-count 3 \
    --enable-addons monitoring \
    --generate-ssh-keys
```

3. Get credentials for your AKS cluster:

```bash
az aks get-credentials --resource-group solar-defect-detection-rg --name solar-defect-cluster
```

4. Verify connectivity:

```bash
kubectl get nodes
```

## Deployment Steps

### 1. Create the Namespace

```bash
kubectl apply -f manifests/namespace.yaml
```

### 2. Deploy Storage Components

```bash
kubectl apply -f manifests/storage/azure-storage-class.yaml
kubectl apply -f manifests/storage/iec61850-data-pvc.yaml
kubectl apply -f manifests/storage/ml-model-storage-pvc.yaml
kubectl apply -f manifests/storage/mongodb-data-pvc.yaml
```

### 3. Deploy Services

```bash
kubectl apply -f manifests/datacollector-processor/service.yaml
kubectl apply -f manifests/microcontroller-simulator/service.yaml
kubectl apply -f manifests/supportingservice/service.yaml
kubectl apply -f manifests/service/prometheus-exporter.yaml
kubectl apply -f manifests/sensor/service.yaml
```

### 4. Deploy Core Infrastructure Components

```bash
kubectl apply -f manifests/datacollector-processor/deployment.yaml
```

### 5. Deploy Microcontroller Simulator & AI Processor

```bash
kubectl apply -f manifests/microcontroller-simulator/deployment.yaml
kubectl apply -f manifests/aiprocessor/namespace.yaml
kubectl apply -f manifests/supportingservice/deployment.yaml
```

### 6. Deploy Sensor Simulators

```bash
kubectl apply -f manifests/sensor/deployment.yaml
```

### 7. Apply Network Policies

```bash
kubectl apply -f manifests/networking/ec61850-simulator-policy.yaml
kubectl apply -f manifests/networking/ml-processing-policy.yaml
kubectl apply -f manifests/networking/scada-interface-policy.yaml
```

## Setting Up Prometheus Monitoring (Optional)

AKS has built-in monitoring with Azure Monitor, but if you want to use Prometheus and Grafana:

1. Install the Prometheus Operator using Helm:

```bash
# Add the Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create a namespace for monitoring
kubectl create namespace monitoring

# Install the Prometheus Operator
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

2. Apply the ServiceMonitor:

```bash
kubectl apply -f manifests/aiprocessor/service-monitor.yaml
```

## Accessing the Application

After deployment, you can access the API server via the LoadBalancer service:

```bash
# Get the external IP of the API server
kubectl get svc api-server -n solar-panel-detection
```

Then access the API at:
```
http://<EXTERNAL-IP>/api/health
```

## Scaling the Application

To scale the components for production:

```bash
# Scale sensor simulators
kubectl scale deployment -n solar-panel-detection irradiance-sensor --replicas=5
kubectl scale deployment -n solar-panel-detection temperature-sensor --replicas=5
kubectl scale deployment -n solar-panel-detection thermal-imaging-sensor --replicas=5

# Scale API servers
kubectl scale deployment -n solar-panel-detection api-server --replicas=3
```

## Cleaning Up

To delete the entire deployment when done:

```bash
# Delete the AKS cluster
az aks delete --resource-group solar-defect-detection-rg --name solar-defect-cluster --yes --no-wait

# Delete the resource group
az group delete --name solar-defect-detection-rg --yes
```
