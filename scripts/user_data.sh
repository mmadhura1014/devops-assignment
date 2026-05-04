#!/bin/bash
set -e

# Update and install Docker
yum update -y
yum install -y docker git aws-cli
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent

# Fetch DB password from Secrets Manager (no hardcoded creds!)
DB_PASS=$(aws secretsmanager get-secret-value \
  --secret-id "${db_secret_arn}" \
  --region "${aws_region}" \
  --query SecretString \
  --output text | python3 -c "import sys,json; print(json.load(sys.stdin)['password'])")

# Pull and run your app (replace with your actual image)
docker run -d \
  --name app \
  --restart always \
  -p 3000:3000 \
  -e DB_HOST="${db_host}" \
  -e DB_PASSWORD="$DB_PASS" \
  -e NODE_ENV=production \
  madhurashree/devops-app:latest

# Configure CloudWatch agent for logs
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/devops-assignment/system",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s