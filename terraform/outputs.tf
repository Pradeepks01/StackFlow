output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_endpoint" {
  value = aws_db_instance.stackflow_db.endpoint
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.stackflow_alerts.arn
}

output "alb_dns" {
  value = aws_lb.stackflow_alb.dns_name
}

output "acm_cert_arn" {
  value = aws_acm_certificate.stackflow_cert.arn
}
