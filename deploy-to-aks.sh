#!/bin/bash
# Script to deploy the Solar Farm Defect Detection System to AKS

set -e  # Exit on any error

echo "🚀 Deploying Solar Farm Defect Detection System to AKS"
echo "------------------------------------------------------"

# 1. Create namespace
echo "📁 Creating namespace..."
kubectl apply -f manifests/namespace.yaml

# 2. Deploy storage components
echo "💾 Deploying storage components..."
kubectl apply -f manifests/storage/azure-storage-class.yaml
kubectl apply -f manifests/storage/mongodb-data-pvc.yaml
kubectl apply -f manifests/storage/iec61850-data-pvc.yaml
kubectl apply -f manifests/storage/ml-model-storage-pvc.yaml

# 3. Deploy services first
echo "🔌 Deploying services..."
kubectl apply -f manifests/datacollector-processor/service.yaml
kubectl apply -f manifests/microcontroller-simulator/service.yaml
kubectl apply -f manifests/supportingservice/service.yaml
kubectl apply -f manifests/service/prometheus-exporter.yaml
kubectl apply -f manifests/sensor/service.yaml

# 4. Deploy core infrastructure components
echo "🏗️ Deploying core infrastructure components..."
kubectl apply -f manifests/datacollector-processor/deployment.yaml
echo "   Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/mongodb -n solar-panel-detection || true

# 5. Deploy microcontroller simulator & AI processor
echo "🔧 Deploying microcontroller simulator & AI processor..."
kubectl apply -f manifests/microcontroller-simulator/deployment.yaml
kubectl apply -f manifests/aiprocessor/namespace.yaml
kubectl apply -f manifests/supportingservice/deployment.yaml

# 6. Deploy sensor simulators
echo "📡 Deploying sensor simulators..."
kubectl apply -f manifests/sensor/deployment.yaml

# 7. Apply network policies
echo "🔒 Applying network policies..."
kubectl apply -f manifests/networking/ec61850-simulator-policy.yaml
kubectl apply -f manifests/networking/ml-processing-policy.yaml
kubectl apply -f manifests/networking/scada-interface-policy.yaml

# 8. Check deployment status
echo "🔍 Checking deployment status..."
kubectl get pods -n solar-panel-detection

# 9. Wait for API service to get external IP
echo "⏳ Waiting for API service to get external IP (this may take a minute)..."
ATTEMPTS=0
MAX_ATTEMPTS=30
EXTERNAL_IP=""

while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
  EXTERNAL_IP=$(kubectl get svc api-server -n solar-panel-detection -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
  
  if [ -n "$EXTERNAL_IP" ] && [ "$EXTERNAL_IP" != "<pending>" ]; then
    break
  fi
  
  ATTEMPTS=$((ATTEMPTS+1))
  echo "   Attempt $ATTEMPTS/$MAX_ATTEMPTS - Waiting for external IP..."
  sleep 10
done

if [ -n "$EXTERNAL_IP" ] && [ "$EXTERNAL_IP" != "<pending>" ]; then
  echo "✅ Deployment complete!"
  echo "📊 API server available at: http://$EXTERNAL_IP/api"
  echo "🔍 Health check endpoint: http://$EXTERNAL_IP/api/health"
else
  echo "⚠️ API service external IP not available yet. Run the following command to check later:"
  echo "   kubectl get svc api-server -n solar-panel-detection"
fi

echo ""
echo "🔧 For troubleshooting, check pod status with:"
echo "   kubectl get pods -n solar-panel-detection"
echo "   kubectl describe pod <pod-name> -n solar-panel-detection"
echo ""
