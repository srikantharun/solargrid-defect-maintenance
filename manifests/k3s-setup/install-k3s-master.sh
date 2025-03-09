#!/bin/bash
# Install K3s server (master)
curl -sfL https://get.k3s.io | sh -

# Display information needed for worker nodes
echo "=================================="
echo "K3s master node setup complete!"
echo "=================================="
echo "Use this token to join worker nodes:"
sudo cat /var/lib/rancher/k3s/server/node-token
echo "Master node IP: $(hostname -I | awk '{print $1}')"
echo "Run this on worker nodes: "
echo "curl -sfL https://get.k3s.io | K3S_URL=https://$(hostname -I | awk '{print $1}'):6443 K3S_TOKEN=\$(cat node-token) sh -"
echo "=================================="

# Copy kubeconfig for easier access
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
echo "Kubeconfig has been copied to ~/.kube/config"
