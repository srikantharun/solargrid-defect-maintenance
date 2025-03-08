# Solar Farm Defect Detection System

This repository contains Kubernetes manifests for deploying a solar panel defect detection system that uses various sensors and AI processing to identify, classify, and recommend solutions for solar panel defects.

## System Architecture

The system is composed of the following main components:

1. **Sensor Pods**: Simulate various sensors (irradiance, temperature, humidity, wind speed, thermal imaging)
2. **Microcontroller Simulator**: Interfaces with physical hardware sensors
3. **Data Collector Processor**: Aggregates sensor data from multiple sources
4. **AI Processor**: Analyzes sensor data to detect defects in solar panels
5. **Supporting Services**: Redis, MongoDB, and MQTT for data management
6. **API Server**: Exposes defect data through a RESTful API

** Estimated planning on motherboard

<img width="620" alt="image" src="https://github.com/user-attachments/assets/6d08c814-895e-4332-8780-32810d0cefa1" />

** Topology of Solar grid stations

<img width="432" alt="image" src="https://github.com/user-attachments/assets/95890808-d422-4063-93fa-38b9a22c1e34" />


## Repository Structure

```
├── README.md
├── argocd
│   ├── applications
│   │   └── solargrid-app.yaml
│   └── projects
│       └── solargrid-project.yaml
├── solarfarm-defect-management.md
└── manifests
    ├── configmap
    │   ├── decision-engine-config.yaml
    │   ├── decision-engine-scripts.yaml
    │   ├── iec61850-config.yaml
    │   ├── iec61850-data-generator.yaml
    │   ├── ml-demo-configmap.yaml
    │   ├── ml-processing-config.yaml
    │   ├── opcua-config.yaml
    │   ├── prometheus-exporter.yaml
    │   └── scada-interface-handler.yaml
    ├── sensor
    │   ├── deployment.yaml
    │   └── service.yaml
    ├── microcontroller-simulator
    │   ├── deployment.yaml
    │   └── service.yaml
    ├── datacollector-processor
    │   ├── deployment.yaml
    │   ├── grid-analytics-readme.md
    │   └── service.yaml
    ├── aiprocessor
    │   ├── README.md
    │   ├── namespace.yaml
    │   ├── prometheus-basic.yaml
    │   ├── prometheus-values.yaml
    │   └── service-monitor.yaml
    ├── namespace.yaml
    ├── networking
    │   ├── ec61850-simulator-policy.yaml
    │   ├── ml-processing-policy.yaml
    │   └── scada-interface-policy.yaml
    ├── supportingservice
    │   ├── deployment.yaml
    │   └── service.yaml
    ├── services
    │   └── prometheus-exporter.yaml
    └── storage
        ├── iec61850-data-pvc.yaml
        └── ml-model-storage-pvc.yaml
```

## Key Features

- Real-time defect detection using multiple sensor data sources
- AI-powered analysis with rule-based and machine learning capabilities
- Comprehensive REST API for data access and management
- Microcontroller interface for hardware integration
- Monitoring and visualization capabilities
- Containerized deployments for easy scaling
- ArgoCD integration for GitOps deployment

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

## Deployment

### Prerequisites

- Kubernetes cluster (1.19+)
- kubectl configured to access your cluster
- ArgoCD installed (optional for GitOps deployment)

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

1. Install ArgoCD in your cluster (if not already installed)
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
http://<your-load-balancer-ip>/api
```

For API documentation, visit:

```
http://<your-load-balancer-ip>/api/documentation
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

## Documentation

For more detailed information about the solar farm defect management system, please refer to the [Solar Farm Defect Management](solarfarm-defect-management.md) document.
