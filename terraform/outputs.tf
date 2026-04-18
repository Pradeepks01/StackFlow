output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "db_instance_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.stackflow_db.endpoint
}

output "db_secret_arn" {
  description = "ARN of the DB password secret in Secrets Manager"
  value       = aws_secretsmanager_secret.db_secret.arn
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for CloudWatch Alerts"
  value       = aws_sns_topic.stackflow_alerts.arn
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.stackflow_alb.dns_name
}

output "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.stackflow_cert.arn
}
