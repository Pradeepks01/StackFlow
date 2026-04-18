# Security Documentation

## Practices
- **Network Policies**: Only frontend can talk to backend.
- **IAM Roles**: Least-privilege IAM roles for EKS nodes.
- **Scanning**: Trivy image scanning in CI.
- **Secrets**: Managed via Kubernetes Secrets (integratable with Secrets Manager).
