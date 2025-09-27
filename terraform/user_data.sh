#!/bin/bash

# Load environment variables from .env
set -a
source ./.env
set +a

echo "Using API key: $AWS_ACCESS_KEY_ID"
echo "Using API key: $AWS_SECRET_ACCESS_KEY"

yum update -y
yum install docker -y
systemctl start docker 
usermod -a -G docker ec2-user