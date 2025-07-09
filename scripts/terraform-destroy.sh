#!/bin/bash

set -e

echo "Destroying Terraform infrastructure with AWS Academy..."

export AWS_DEFAULT_REGION=us-east-1

cd terraform

echo "1. Planning Terraform destruction..."
terraform plan -destroy -out=destroy-plan

echo "2. Destroying Terraform resources..."
terraform apply destroy-plan

echo "3. Terraform destruction completed!"