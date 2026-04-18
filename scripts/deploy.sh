#!/bin/bash
ENV=${1:-dev}
echo "Deploying StackFlow to $ENV environment..."

helm upgrade --install stackflow ./helm/stackflow \
    --namespace $ENV \
    --create-namespace \
    --values ./helm/stackflow/values.yaml \
    --values ./helm/stackflow/values-$ENV.yaml
