#!/bin/bash

set -e

echo "Setting up AWS Academy credentials..."

echo "1. Checking current AWS credentials..."
aws sts get-caller-identity

echo "2. Current AWS configuration is ready!"
echo "   Account ID: $(aws sts get-caller-identity --query Account --output text)"
echo "   User: $(aws sts get-caller-identity --query Arn --output text)"
echo "   Region: $(aws configure get region)"

echo "3. Testing AWS permissions..."
aws ec2 describe-regions --region us-east-1 > /dev/null && echo "   EC2 permissions OK"
aws iam get-role --role-name LabRole > /dev/null && echo "   IAM permissions OK"

echo "4. Setting environment variables..."
export AWS_DEFAULT_REGION=us-east-1
export AWS_REGION=us-east-1

echo "5. AWS Academy setup completed!"
echo "   Use existing AWS credentials"
echo "   Region: us-east-1"
echo "   Account: 720049726178"