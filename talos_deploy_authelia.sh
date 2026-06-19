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
echo -e "${BLUEBOLD}       Starting End-to-End Authelia Deployment         ${NC}"
echo -e "${BLUEBOLD}====================================================${NC}"

# 1. Ensure we are in the correct directory execution context
if [ ! -d "authelia" ]; then
    echo -e "${REDBOLD}Error: 'authelia' subfolder not found.${NC}"
    echo "Please execute this script from the directory containing your storage and deployment manifests."
    exit 1
fi

# 2. Complete Teardown to prevent immutable state conflicts
echo -e "\n${YELLOWBOLD}[1/4] Purging existing Authelia workloads and locks...${NC}"
kubectl delete deployment authelia --ignore-not-found=true
kubectl delete pvc authelia-config-pvc --ignore-not-found=true
kubectl delete pv authelia-nfs-pv --ignore-not-found=true

# 3. Apply the Secrets and Network Storage Layer
echo -e "\n${YELLOWBOLD}[2/4] Applying Authelia Secrets Configuration...${NC}"
kubectl apply -f authelia/authelia-secrets.yaml

echo -e "\n${YELLOWBOLD}[2/4] Applying TrueNAS NFS Volume Configuration...${NC}"
kubectl apply -f authelia/authelia-storage.yaml


# Add the official Authelia repository
helm repo add authelia https://charts.authelia.com
helm repo update

# Install Authelia into the target namespace
helm install authelia authelia/authelia --namespace authelia --values authelia/authelia-values.yaml

scp authelia/authelia-users.yaml brenden@vanhalen-c:/mnt/nfs/talos/authelia/users.yml

kubectl rollout restart daemonset authelia -n authelia


# 4. Wait and verify the storage subsystem binds successfully
#echo -e "${BLUEBOLD}Waiting for PersistentVolumeClaim to transition to Bound state...${NC}"
#while true; do
#    STATUS=$(kubectl get pvc authelia-config-pvc -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
#    if [ "$STATUS" = "Bound" ]; then
#        echo -e "${GREENBOLD}??? Storage bound successfully.${NC}"
#        break
#    elif [ "$STATUS" = "Failed" ]; then
#        echo -e "${REDBOLD}??? Storage mapping failed. Inspecting events:${NC}"
#        kubectl describe pvc authelia-config-pvc
#        exit 1
#    fi
#    sleep 2
#done

# 5. Spin up the Core Workload Application Layer
#echo -e "\n${YELLOWBOLD}[3/4] Launching Authelia Deployment Workload...${NC}"
#kubectl apply -f authelia/authelia-deployment.yaml
#kubectl apply -f authelia/authelia-service.yaml


#kubectl rollout restart daemonset authelia -n authelia


# 6. Monitor rollout live until fully ready
#echo -e "\n${YELLOWBOLD}[4/4] Tracking container lifecycle rollout...${NC}"
#echo "Waiting for the pod to pull image, mount volume, and clear health probes..."

# Utilize Kubernetes native wait configuration for tracking rollout
#kubectl rollout status deployment/authelia --timeout=120s

#echo -e "\n${GREENBOLD}====================================================${NC}"
#echo -e "${GREENBOLD}??? Authelia End-to-End Deployment Complete!            ${NC}"
#echo -e "${GREENBOLD}====================================================${NC}"

# 7. Post-deployment live validation check
#echo -e "${BLUEBOLD}Verifying NFS filesystem visibility inside pod workspace:${NC}"
#POD_NAME=$(kubectl get pods -l app=authelia -o jsonpath='{.items[0].metadata.name}')
#echo -e "Executing 'ls -la' on mount point inside pod: ${YELLOWBOLD}$POD_NAME${NC}"
#echo "----------------------------------------------------"
#kubectl exec -it "$POD_NAME" -- ls -la /www/assets
#echo "----------------------------------------------------"
