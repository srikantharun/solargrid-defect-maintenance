kubectl get job thermal-model-trainer -n solar-panel-detection

kubectl exec -it $(kubectl get pod -l app=ai-processor -n solar-panel-detection -o jsonpath='{.items[0].metadata.name}') -n solar-panel-detection -- ls -l /models/

az aks nodepool delete \
    --resource-group aks-demo-rg \
    --cluster-name private-aks-cluster \
    --name mlnodepool
