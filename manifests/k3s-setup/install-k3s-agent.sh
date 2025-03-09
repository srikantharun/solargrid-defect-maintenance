#!/bin/bash
# Usage: ./install-k3s-agent.sh <MASTER_IP> <TOKEN>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <MASTER_IP> <TOKEN>"
    exit 1
fi

MASTER_IP=$1
TOKEN=$2

# Install K3s agent (worker)
curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${TOKEN} sh -

echo "=================================="
echo "K3s agent node joined successfully!"
echo "=================================="
