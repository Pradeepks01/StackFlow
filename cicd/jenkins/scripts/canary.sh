#!/bin/bash
echo "Initiating Canary Deployment..."
kubectl apply -f helm/stackflow/templates/rollout.yaml -n test
# Argo Rollouts handles the weights automatically based on the spec
