# Solar Farm Defect Detection System for K3s

This repository contains Kubernetes manifests for deploying a solar panel defect detection system on K3s - a lightweight Kubernetes distribution ideal for edge computing and IoT environments.

## System Architecture

The system is composed of the following main components:

1. **Sensor Pods**: Simulate various sensors (irradiance, temperature, humidity, wind speed, thermal imaging)
2. **Microcontroller Simulator**: Interfaces with physical hardware sensors
3. **Data Collector Processor**: Aggregates sensor data from multiple sources
4. **AI Processor**: Analyzes sensor data to detect defects in solar panels
5. **Supporting Services**: Redis, MongoDB, and MQTT for data management
6. **API Server**: Exposes defect data through a RESTful API

## Functional pods on motherboard

<img width="1346" alt="image" src="https://github.com/user-attachments/assets/9f89ba65-9b9e-42cb-80df-9ef635661715" />


## Topology Of Solar Panel Grid Station

<img width="432" alt="image" src="https://github.com/user-attachments/assets/95890808-d422-4063-93fa-38b9a22c1e34" />

## Key Features

- Real-time defect detection using multiple sensor data sources
- AI-powered analysis with rule-based and machine learning capabilities
- Comprehensive REST API for data access and management
- Microcontroller interface for hardware integration
- Monitoring and visualization capabilities
- Containerized deployments for easy scaling
- Optimized for lightweight K3s deployment on edge devices
- ArgoCD integration for GitOps deployment

## Hardware Requirements

For a production-like K3s cluster, we recommend:

- **Master Node**: 
  - 2 CPU cores
  - 2GB RAM minimum
  - 20GB disk space
  
- **Worker Nodes** (at least one):
  - 2 CPU cores
  - 4GB RAM minimum
  - 40GB disk space

For a real solar farm deployment, we recommend additional worker nodes positioned near solar panel arrays for direct sensor connections.

## K3s Setup

### Master Node Setup

1. Run the master setup script:
   ```bash
   chmod +x k3s-setup/install-k3s-master.sh
   ./k3s-setup/install-k3s-master.sh
   ```

2. Make note of the node token and IP address displayed at the end of the installation.

### Worker Node Setup

1. Run the worker setup script with the master IP and token:
   ```bash
   chmod +x k3s-setup/install-k3s-agent.sh
   ./k3s-setup/install-k3s-agent.sh <MASTER_IP> <NODE_TOKEN>
   ```

2. Verify the node joined the cluster:
   ```bash
   kubectl get nodes
   ```

### Rancher Management (Optional)

For a management UI, install Rancher by following the instructions in `k3s-setup/rancher-setup.md`.

## Deployment

### Standard Deployment

1. Deploy the namespace:
   ```bash
   kubectl apply -f manifests/namespace.yaml
   ```

2. Deploy storage components:
   ```bash
   kubectl apply -f manifests/storage/
   ```

3. Deploy supporting services:
   ```bash
   kubectl apply -f manifests/supportingservice/
   ```

4. Deploy sensors and data collectors:
   ```bash
   kubectl apply -f manifests/configmap/
   kubectl apply -f manifests/sensor/
   kubectl apply -f manifests/microcontroller-simulator/
   kubectl apply -f manifests/datacollector-processor/
   ```

5. Deploy AI processor:
   ```bash
   kubectl apply -f manifests/aiprocessor/
   ```

6. Apply network policies:
   ```bash
   kubectl apply -f manifests/networking/
   ```

### ArgoCD Deployment (GitOps)

1. Install ArgoCD in your cluster:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. Apply the project configuration:
   ```bash
   kubectl apply -f argocd/projects/solargrid-project.yaml
   ```

3. Apply the application configuration:
   ```bash
   kubectl apply -f argocd/applications/solargrid-app.yaml
   ```

## API Access

Once deployed, the API server will be available at:

```
http://<any-node-ip>:30080/api
```

For API documentation, visit:

```
http://<any-node-ip>:30080/api/documentation
```

## Monitoring

Monitoring is provided through Prometheus and Grafana:

1. Deploy monitoring components:
   ```bash
   kubectl apply -f manifests/services/prometheus-exporter.yaml
   ```

2. Access Grafana dashboard:
   ```bash
   kubectl port-forward -n solar-panel-detection svc/grafana 3000:80
   ```

## Edge Optimization

This deployment is optimized for edge environments with:

1. Local storage using K3s's built-in local-path provisioner
2. NodePort services instead of LoadBalancers
3. Minimal resource requests
4. Configurable data retention for limited storage scenarios

## Supported Defect Types

The system can detect various types of solar panel defects including:

- Hot spots
- Cell cracks
- Bypass diode failures
- Delamination
- Potential-induced degradation
- Overheating
- Dust/dirt accumulation
- Moisture ingress
- Mounting and structural issues

## Documentation

For more detailed information about the solar farm defect management system, please refer to the [Solar Farm Defect Management](solarfarm-defect-management.md) document.
