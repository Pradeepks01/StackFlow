module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "stackflow-cluster"
  cluster_version = "1.29"

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    # spot nodes - these handle most of the workload
    spot = {
      name = "stackflow-spot-nodes"

      min_size     = 1
      max_size     = 4
      desired_size = 2

      # using graviton (arm) + multiple types for better spot availability
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

    # on-demand for stuff that cant handle interruptions
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
    Environment = var.environment
    Project     = "StackFlow"
  }
}
