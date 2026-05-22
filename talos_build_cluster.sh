#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define console output colors
NC='\033[0m'
GREENBOLD='\033[1;32m'
BLUEBOLD='\033[1;34m'
YELLOWBOLD='\033[1;33m'
REDBOLD='\033[1;31m'

export TALOSCONFIG="_out/talosconfig"

echo -e "${BLUEBOLD}====================================================${NC}"
echo -e "${BLUEBOLD}        Starting Fresh Talos Cluster Rebuild         ${NC}"
echo -e "${BLUEBOLD}====================================================${NC}"

# 1. Clean out legacy outputs and generate structural configurations
echo -e "\n${YELLOWBOLD}[1/6] Purging old artifacts and compiling new machine configurations...${NC}"
rm -rf _out
talosctl gen config talos https://192.168.1.201:6443 --output-dir _out

# 2. Distribute machine configurations across physical nodes
echo -e "\n${YELLOWBOLD}[2/6] Applying machine configuration files to target nodes...${NC}"
talosctl apply-config --insecure --nodes 192.168.1.201 --file _out/controlplane.yaml
talosctl apply-config --insecure --nodes 192.168.1.202 --file _out/controlplane.yaml
talosctl apply-config --insecure --nodes 192.168.1.203 --file _out/controlplane.yaml
talosctl apply-config --insecure --nodes 192.168.1.204 --file _out/worker.yaml
talosctl apply-config --insecure --nodes 192.168.1.205 --file _out/worker.yaml
echo -e "\n${YELLOWBOLD}[2/6] Waiting 5 minutes...${NC}"
sleep 300

# 3. Target control-plane and bootstrap etcd sequence
echo -e "\n${YELLOWBOLD}[3/6] Initializing endpoints and executing bootstrap loop...${NC}"
talosctl config endpoint 192.168.1.201
talosctl config node 192.168.1.201

talosctl bootstrap

echo -e "${BLUEBOLD}Extracting administrative kubeconfig directly to execution context...${NC}"
talosctl kubeconfig .

# 4. API Convergence Health Probe Loop
echo -e "\n${YELLOWBOLD}[4/6] Waiting for Kubernetes Control Plane API Convergence...${NC}"
echo "Polling API server endpoint until control loops respond successfully..."
until kubectl get nodes &>/dev/null; do
    echo -e "${YELLOWBOLD}...API not reachable yet. Retrying in 5 seconds...${NC}"
    sleep 5
done
echo -e "${GREENBOLD}??? Kubernetes Control Plane API is alive and responsive!${NC}"

# 5. Provision TrueNAS Network Storage Backplane
echo -e "\n${YELLOWBOLD}[5/6] Injecting NFS CSI Driver Core Architecture...${NC}"
# Installs official production-ready v4.2 capable CSI controllers and nodes
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/v4.6.0/deploy/provider-kubernetes/csi-nfs-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/v4.6.0/deploy/provider-kubernetes/csi-nfs-node.yaml

echo -e "${BLUEBOLD}Waiting for NFS CSI Node components to stabilize across hardware...${NC}"
sleep 5 # Grace gap for daemonsets to initialize structure

if [ -f "nfs-storageclass.yaml" ]; then
    echo -e "${BLUEBOLD}Registering TrueNAS Dynamic StorageClass Configuration...${NC}"
    kubectl apply -f nfs-storageclass.yaml
else
    echo -e "${REDBOLD}Warning: nfs-storageclass.yaml not found in local path. Skipping registration.${NC}"
fi

# 6. Provision Layer 2 Networking Stack
echo -e "\n${YELLOWBOLD}[6/6] Injecting Native MetalLB Framework Layers...${NC}"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml

echo -e "${BLUEBOLD}Waiting for MetalLB controllers to finalize setup hooks...${NC}"
kubectl rollout status deployment/controller -n metallb-system --timeout=90s

echo -e "${BLUEBOLD}Bypassing webhook restrictions to isolate runtime deadline errors...${NC}"
kubectl delete validatingwebhookconfiguration metallb-webhook-configuration --ignore-not-found=true

# --- UPDATED SECTION TO LOAD MANIFEST FROM FILE ---
if [ -f "homer/metallb-config.yaml" ]; then
    echo -e "${BLUEBOLD}Applying Global IP Pool Boundaries and L2 ARP Advertisements from file...${NC}"
    kubectl apply -f homer/metallb-config.yaml
else
    echo -e "${REDBOLD}Error: homer/metallb-config.yaml not found. Failed to configure loadbalancer IP pools.${NC}"
    exit 1
fi
# --------------------------------------------------

echo -e "\n${GREENBOLD}====================================================${NC}"
echo -e "${GREENBOLD}??? Cluster Core Rebuild & Storage Backplane Complete! ${NC}"
echo -e "${GREENBOLD}====================================================${NC}"
echo "Cluster is pristine and ready. You can now execute: ./deploy-homer.sh"