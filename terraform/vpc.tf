# --- VPC (Cost-Optimized: No NAT Gateway) ---
# NAT Gateway costs ~$32/month. For demo/dev, use public subnets for nodes instead.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = "stackflow-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2) # 2 AZs instead of 3 (saves cross-AZ transfer costs)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # ❌ NAT Gateway DISABLED — saves $32+/month
  # For production: set enable_nat_gateway = true
  enable_nat_gateway = false

  # EKS nodes in public subnets need this for outbound access
  map_public_ip_on_launch = true

  # Required tags for EKS auto-discovery
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/stackflow-cluster"   = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/stackflow-cluster"   = "shared"
  }

  tags = {
    Environment = var.environment
    Project     = "StackFlow"
    CostCenter  = "optimized"
  }
}
