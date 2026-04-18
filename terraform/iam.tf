# --- IAM Roles ---

resource "aws_iam_role" "eks_cluster_role" {
  name = "stackflow-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "stackflow-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# --- Policy Data Sources (safe ARN resolution) ---

data "aws_iam_policy" "eks_worker_node" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eks_cni" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "ecr_read_only" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# --- Policy Attachments ---

resource "aws_iam_role_policy_attachment" "eks_node_WorkerNodePolicy" {
  policy_arn = data.aws_iam_policy.eks_worker_node.arn
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_CNI_Policy" {
  policy_arn = data.aws_iam_policy.eks_cni.arn
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_RegistryPolicy" {
  policy_arn = data.aws_iam_policy.ecr_read_only.arn
  role       = aws_iam_role.eks_node_role.name
}
