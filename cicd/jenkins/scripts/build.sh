#!/bin/bash
echo "Building Docker images..."
docker build -t $ECR_REGISTRY/stackflow-backend:$BUILD_NUMBER ./app/backend
docker build -t $ECR_REGISTRY/stackflow-frontend:$BUILD_NUMBER ./app/frontend

echo "Pushing to ECR..."
docker push $ECR_REGISTRY/stackflow-backend:$BUILD_NUMBER
docker push $ECR_REGISTRY/stackflow-frontend:$BUILD_NUMBER
