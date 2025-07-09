.PHONY: help setup init plan apply destroy deploy test clean

help:
	@echo "Available commands:"
	@echo "  setup      - Setup AWS Academy credentials"
	@echo "  init       - Initialize Terraform"
	@echo "  plan       - Plan Terraform changes"
	@echo "  apply      - Apply Terraform changes"
	@echo "  destroy    - Destroy Terraform resources"
	@echo "  deploy     - Deploy services to Kubernetes"
	@echo "  test       - Run tests"
	@echo "  clean      - Clean up temporary files"

setup:
	@echo "Setting up AWS Academy credentials..."
	./scripts/setup-lab-role.sh

init:
	@echo "Initializing Terraform..."
	cd terraform && terraform init

plan:
	@echo "Planning Terraform changes..."
	cd terraform && terraform plan -out=tfplan

apply:
	@echo "Applying Terraform changes..."
	cd terraform && terraform apply tfplan

destroy:
	@echo "Destroying Terraform resources..."
	cd terraform && terraform destroy -auto-approve

deploy:
	@echo "Deploying services to Kubernetes..."
	./scripts/deploy.sh

test:
	@echo "Running tests..."
	cd auth-service && python -m pytest tests/
	cd video-service && python -m pytest tests/

clean:
	@echo "Cleaning up temporary files..."
	rm -f terraform/tfplan
	rm -f terraform/destroy-plan
	rm -rf terraform/.terraform
	rm -f terraform/.terraform.lock.hcl

infra-up:
	@echo "Setting up complete infrastructure with AWS Academy..."
	./scripts/setup-lab-role.sh
	./scripts/terraform-init.sh
	./scripts/deploy.sh

infra-down:
	@echo "Tearing down infrastructure..."
	./scripts/terraform-destroy.sh
