CLUSTER_NAME=minuevoclusterdelinux
AWS_REGION=us-east-1
SERVICE_NAME=minuevoservice_cli
APPNAME=mi_app_por_cli
createCluster:
	aws ecs create-cluster --cluster-name ${CLUSTER_NAME}

createRole:
	aws iam create-role --role-name ecsTaskExecutionRole3 \
    --assume-role-policy-document file://ecs-tasks-trust-policy.json

	aws iam attach-role-policy --role-name ecsTaskExecutionRole3 \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

task:
	aws ecs register-task-definition --region ${AWS_REGION} \
    --cli-input-json file://task-definition-fg.json

createService:
	aws ecs create-service \
    --cluster ${CLUSTER_NAME} \
    --service-name ${SERVICE_NAME} \
    --task-definition ${APPNAME} \
    --desired-count 1  \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-026fc3ecd465520b0, subnet-007f788d99975d4c2],securityGroups=[sg-09dd11796111b70a7],assignPublicIp=ENABLED}" \

updateService:
	aws ecs update-service --cluster ${CLUSTER_NAME} \
    --desired-count 3  \
    --service ${SERVICE_NAME} \
    --region ${AWS_REGION}  \
    --task-definition ${APPNAME}        



