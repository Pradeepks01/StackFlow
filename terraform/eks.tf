# --- EKS Cluster (Cost-Optimized) ---

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "stackflow-cluster"
  cluster_version = "1.29"

  # Access Settings
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # --- Cost-Optimized Node Groups ---
  eks_managed_node_groups = {

    # Spot instances for non-critical workloads (70-90% cheaper)
    spot = {
      name = "stackflow-spot-nodes"

      min_size     = 1
      max_size     = 4
      desired_size = 2

      # ARM-based Graviton = 20-30% cheaper than x86
      # Multiple types for better spot availability
      instance_types = ["t4g.medium", "t3a.medium", "t3.medium"]
      capacity_type  = "SPOT"
      ami_type       = "AL2_ARM_64"

      labels = {
        workload = "general"
        spot     = "true"
      }

      taints = []

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }

    # On-demand for critical workloads (database connections, ingress controller)
    ondemand = {
      name = "stackflow-ondemand-nodes"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t4g.small"]
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2_ARM_64"

      labels = {
        workload = "critical"
        spot     = "false"
      }

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = {
    Environment  = var.environment
    Project      = "StackFlow"
    CostCenter   = "optimized"
  }
}
