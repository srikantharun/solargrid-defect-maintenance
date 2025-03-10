az aks nodepool add \
    --resource-group aks-demo-rg \
    --cluster-name private-aks-cluster \
    --name mlnodepool \
    --node-count 1 \
    --node-vm-size Standard_NC4as_T4_v3 \
    --labels workload=ml gpu=enabled \
    --node-taints ml=true:NoSchedule
