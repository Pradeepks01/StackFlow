#!/bin/bash
echo "Cleaning up StackFlow resources..."
helm uninstall stackflow -n dev || true
helm uninstall stackflow -n test || true
helm uninstall stackflow -n prod || true

echo "Deleting namespaces..."
kubectl delete ns dev test prod || true
