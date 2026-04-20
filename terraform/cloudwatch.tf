resource "aws_cloudwatch_log_group" "stackflow_logs" {
  name              = "/aws/eks/stackflow-cluster/logs"
  retention_in_days = 7
}

resource "aws_sns_topic" "stackflow_alerts" {
  name = "stackflow-alerts"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "stackflow-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU above 80% for 4 min"
  alarm_actions       = [aws_sns_topic.stackflow_alerts.arn]
  ok_actions          = [aws_sns_topic.stackflow_alerts.arn]
}
