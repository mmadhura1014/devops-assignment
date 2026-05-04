variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Used as a prefix for all resources"
  default     = "devops-assignment"
}

variable "environment" {
  description = "staging or production"
  default     = "staging"
}

variable "instance_type" {
  description = "EC2 instance size"
  default     = "t3.micro"   # free tier eligible
}

variable "db_username" {
  default = "dbadmin"
}

variable "db_password" {
  description = "RDS master password — pass via env or tfvars, never hardcode"
  sensitive   = true
}

variable "my_ip" {
  description = "Your IP for SSH access — run: curl ifconfig.me"
}