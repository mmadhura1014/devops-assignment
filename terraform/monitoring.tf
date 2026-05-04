resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ec2/devops-assignment/app"
  retention_in_days = 14

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
