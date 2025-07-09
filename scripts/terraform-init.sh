#!/bin/bash

set -e

echo "Initializing Terraform infrastructure with AWS Academy..."

export AWS_DEFAULT_REGION=us-east-1

cd terraform

echo "1. Initializing Terraform..."
terraform init

echo "2. Validating Terraform configuration..."
terraform validate

echo "3. Planning Terraform deployment..."
terraform plan -out=tfplan

echo "4. Applying Terraform configuration..."
terraform apply tfplan

echo "5. Terraform deployment completed!"
echo "Outputs:"
terraform output

echo "6. Configuring kubectl..."
aws eks update-kubeconfig --region $(terraform output -raw aws_region) --name $(terraform output -raw cluster_name)

echo "Infrastructure deployment completed successfully!"