#!/bin/bash
echo "Initiating Blue-Green Deployment..."
kubectl apply -f helm/stackflow/templates/rollout.yaml -n prod
