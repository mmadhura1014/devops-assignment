output "alb_dns_name" {
  description = "Hit this URL to reach your app"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ec2_public_ip" {
  description = "SSH directly for debugging"
  value       = aws_instance.app.public_ip
}

output "rds_endpoint" {
  description = "DB connection string (without password)"
  value       = module.db.db_instance_endpoint
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/devops-assignment ec2-user@${aws_instance.app.public_ip}"
}