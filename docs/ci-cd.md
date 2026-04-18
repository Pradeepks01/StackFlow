# CI/CD Pipeline Documentation

## Flow
1. **GitHub Actions**: Primes the image by building and pushing to ECR on branch pushes.
2. **Security**: Trivy scans images for vulnerabilities.
3. **Deployment**:
   - `devops` -> Deploys to `dev`.
   - `test` -> Deploys to `test` using Canary.
   - `main` -> Deploys to `prod` using Blue-Green.
