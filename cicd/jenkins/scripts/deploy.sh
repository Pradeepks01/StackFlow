#!/bin/bash
ENVIRONMENT=$1
echo "Deploying to $ENVIRONMENT..."
helm upgrade --install stackflow ./helm/stackflow \
  --namespace $ENVIRONMENT \
  --values ./helm/stackflow/values-$ENVIRONMENT.yaml \
  --set backend.image.tag=$BUILD_NUMBER \
  --set frontend.image.tag=$BUILD_NUMBER
