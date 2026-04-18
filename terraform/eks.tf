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

  # Unified Managed Node Groups (single source of truth — nodegroup.tf removed)
  eks_managed_node_groups = {
    stackflow = {
      name = "stackflow-nodes"
      
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.small"]
      
      # Ensure nodes have the correct IAM policies
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = "StackFlow"
  }
}
