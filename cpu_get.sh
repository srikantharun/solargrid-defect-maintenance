az aks nodepool add \
    --resource-group aks-demo-rg \
    --cluster-name private-aks-cluster \
    --name cpumlpool \
    --node-count 1 \
    --node-vm-size Standard_D16s_v3 \
    --labels workload=ml \
    --node-taints ml=true:NoSchedule
