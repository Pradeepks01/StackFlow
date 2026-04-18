# StackFlow Architecture

## Overview
StackFlow is a three-tier application (Frontend, Backend, Database) deployed on AWS EKS with a full GitOps and Observability stack.

## Components
1. **Frontend**: React-based SPA served by Nginx.
2. **Backend**: Node.js Express API.
3. **Database**: Managed RDS PostgreSQL.
4. **Networking**: VPC with segregated subnets.
5. **Deployment**: Argo CD Syncing Helm charts.
6. **Strategies**: Canary (Staging) and Blue-Green (Production).
