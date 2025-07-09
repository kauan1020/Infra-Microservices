#!/bin/bash

set -e

AWS_REGION=${AWS_REGION:-us-east-1}
CLUSTER_NAME=${CLUSTER_NAME:-fiap-x-dev}
NAMESPACE=${NAMESPACE:-fiap-x-dev}

echo "🚀 Deploying FIAP X Microservices to EKS (Simple Version)..."

echo "1. 📊 Getting Terraform outputs..."
cd terraform
AUTH_DB_SECRET_ARN=$(terraform output -raw rds_auth_secret_arn)
VIDEO_DB_SECRET_ARN=$(terraform output -raw rds_video_secret_arn)
JWT_SECRET_ARN=$(terraform output -raw jwt_secret_arn)
REDIS_SECRET_ARN=$(terraform output -raw redis_secret_arn)
EFS_FILE_SYSTEM_ID=$(terraform output -raw efs_file_system_id)
AWS_ACCOUNT_ID=$(terraform output -raw aws_account_id)
cd ..

echo "2. ⚙️ Updating kubeconfig..."
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

echo "3. 🏗️ Creating namespace..."
kubectl apply -f k8s/namespace.yaml

echo "4. 🔧 Installing EFS CSI Driver..."
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.7"

echo "5. 🔐 Creating RBAC..."
kubectl apply -f k8s/rbac/service-accounts.yaml

echo "6. ⚙️ Creating ConfigMaps..."
kubectl apply -f k8s/configmaps/app-config.yaml

echo "7. 🔑 Creating secrets..."
kubectl apply -f k8s/secrets/secrets.yaml

echo "8. 💾 Creating EFS Storage Class..."
export EFS_FILE_SYSTEM_ID
envsubst < k8s/storage/efs-storage-class.yaml | kubectl apply -f -

echo "9. 🔍 Deploying SonarQube..."
kubectl apply -f k8s/sonarqube/sonarqube.yaml

echo "10. 📊 Deploying Monitoring (Prometheus)..."
kubectl apply -f k8s/monitoring/prometheus.yaml

echo "11. 🗄️ Deploying Redis..."
kubectl apply -f k8s/redis/deployment.yaml

echo "12. 📨 Deploying Kafka..."
kubectl apply -f k8s/kafka/deployment.yaml

echo "13. ⏳ Waiting for core services..."
echo "   - Waiting for Redis..."
kubectl wait --for=condition=ready pod -l app=redis -n $NAMESPACE --timeout=300s
echo "   - Waiting for Zookeeper..."
kubectl wait --for=condition=ready pod -l app=zookeeper -n $NAMESPACE --timeout=300s
echo "   - Waiting for Kafka..."
kubectl wait --for=condition=ready pod -l app=kafka -n $NAMESPACE --timeout=300s

echo "14. 🔄 Running database migrations..."
export AUTH_DB_SECRET_ARN VIDEO_DB_SECRET_ARN
envsubst < k8s/jobs/db-migration.yaml | kubectl apply -f -

echo "15. 🔐 Deploying Auth Service..."
export AUTH_DB_SECRET_ARN JWT_SECRET_ARN REDIS_SECRET_ARN AWS_ACCOUNT_ID AWS_REGION
envsubst < k8s/auth-service/deployment.yaml | kubectl apply -f -

echo "16. 🎥 Deploying Video Service..."
export VIDEO_DB_SECRET_ARN REDIS_SECRET_ARN AWS_ACCOUNT_ID AWS_REGION
envsubst < k8s/video-service/deployment.yaml | kubectl apply -f -

echo "17. 🛡️ Creating Network Policies..."
kubectl apply -f k8s/network-policies/network-policies.yaml

echo "18. 📈 Creating Horizontal Pod Autoscaler..."
kubectl apply -f k8s/autoscaling/hpa.yaml

echo "19. ⏳ Waiting for application deployments..."
echo "   - Waiting for Auth Service..."
kubectl rollout status deployment/auth-service -n $NAMESPACE --timeout=300s
echo "   - Waiting for Video Service..."
kubectl rollout status deployment/video-service -n $NAMESPACE --timeout=300s

echo "20. 🔍 Checking service status..."
kubectl get pods -n $NAMESPACE
kubectl get services -n $NAMESPACE

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📍 Service URLs (via kubectl port-forward):"
echo "   🔐 Auth Service: kubectl port-forward svc/auth-service 8000:8000 -n $NAMESPACE"
echo "   🎥 Video Service: kubectl port-forward svc/video-service 8001:8001 -n $NAMESPACE"
echo "   🔍 SonarQube: kubectl port-forward svc/sonarqube 9000:9000 -n sonarqube"
echo "   📊 Prometheus: kubectl port-forward svc/prometheus 9090:9090 -n monitoring"
echo ""
echo "🔍 Monitoring Commands:"
echo "   kubectl get pods -n $NAMESPACE"
echo "   kubectl logs -f deployment/auth-service -n $NAMESPACE"
echo "   kubectl logs -f deployment/video-service -n $NAMESPACE"
echo "   kubectl get hpa -n $NAMESPACE"