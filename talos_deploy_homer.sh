#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define console output colors
REDBOLD='\033[1;31m'
GREENBOLD='\033[1;32m'
BLUEBOLD='\033[1;34m'
YELLOWBOLD='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUEBOLD}====================================================${NC}"
echo -e "${BLUEBOLD}       Starting End-to-End Homer Deployment         ${NC}"
echo -e "${BLUEBOLD}====================================================${NC}"

# 1. Ensure we are in the correct directory execution context
if [ ! -d "homer" ]; then
    echo -e "${REDBOLD}Error: 'homer' subfolder not found.${NC}"
    echo "Please execute this script from the directory containing your storage and deployment manifests."
    exit 1
fi

# 2. Complete Teardown to prevent immutable state conflicts
echo -e "\n${YELLOWBOLD}[1/4] Purging existing Homer workloads and locks...${NC}"
kubectl delete deployment homer --ignore-not-found=true
kubectl delete pvc homer-config-pvc --ignore-not-found=true
kubectl delete pv homer-nfs-pv --ignore-not-found=true

# 3. Apply the Network Storage Layer
echo -e "\n${YELLOWBOLD}[2/4] Applying TrueNAS NFS Volume Configuration...${NC}"
kubectl apply -f homer/homer-storage.yaml

# 4. Wait and verify the storage subsystem binds successfully
echo -e "${BLUEBOLD}Waiting for PersistentVolumeClaim to transition to Bound state...${NC}"
while true; do
    STATUS=$(kubectl get pvc homer-config-pvc -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
    if [ "$STATUS" = "Bound" ]; then
        echo -e "${GREENBOLD}??? Storage bound successfully.${NC}"
        break
    elif [ "$STATUS" = "Failed" ]; then
        echo -e "${REDBOLD}??? Storage mapping failed. Inspecting events:${NC}"
        kubectl describe pvc homer-config-pvc
        exit 1
    fi
    sleep 2
done

# 5. Spin up the Core Workload Application Layer
echo -e "\n${YELLOWBOLD}[3/4] Launching Homer Deployment Workload...${NC}"
kubectl apply -f homer/homer-deployment.yaml
kubectl apply -f homer/homer-service.yaml

# 6. Monitor rollout live until fully ready
echo -e "\n${YELLOWBOLD}[4/4] Tracking container lifecycle rollout...${NC}"
echo "Waiting for the pod to pull image, mount volume, and clear health probes..."

# Utilize Kubernetes native wait configuration for tracking rollout
kubectl rollout status deployment/homer --timeout=120s

echo -e "\n${GREENBOLD}====================================================${NC}"
echo -e "${GREENBOLD}??? Homer End-to-End Deployment Complete!            ${NC}"
echo -e "${GREENBOLD}====================================================${NC}"

# 7. Post-deployment live validation check
echo -e "${BLUEBOLD}Verifying NFS filesystem visibility inside pod workspace:${NC}"
POD_NAME=$(kubectl get pods -l app=homer -o jsonpath='{.items[0].metadata.name}')
echo -e "Executing 'ls -la' on mount point inside pod: ${YELLOWBOLD}$POD_NAME${NC}"
echo "----------------------------------------------------"
kubectl exec -it "$POD_NAME" -- ls -la /www/assets
echo "----------------------------------------------------"
