#!/bin/bash
set -e

echo "🚀 Setting up StackFlow Environment..."

# Get the project root directory
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$PROJECT_ROOT"

# 1. Initialize Backend
echo "Installing backend dependencies in app/backend..."
cd "$PROJECT_ROOT/app/backend"
npm install

# 2. Initialize Frontend
echo "Installing frontend dependencies in app/frontend..."
cd "$PROJECT_ROOT/app/frontend"
npm install

# 3. Check Docker
if command -v docker &> /dev/null
then
    echo "Docker found. Building local containers..."
    cd "$PROJECT_ROOT/docker"
    docker-compose build
else
    echo "Docker not found. Skipping local build."
fi

echo "✅ Setup complete. Happy DevOps-ing!"
