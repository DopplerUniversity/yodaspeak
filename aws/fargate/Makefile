AWS_TERRAFORM_FLAGS = \
	-var "region=${REGION}" \
	-var "vpc_id=${VPC_ID}" \
	-var "subnet_id=${SUBNET_ID}" \
	-var "cpu=${FARGATE_CPU}" \
	-var "memory=${FARGATE_MEMORY}" \
	-var "port=${PORT}" \
	-var "tls_port=${TLS_PORT}" \
	-var "doppler_token=${DOPPLER_AWS_APP_SERVICE_TOKEN}"

.PHONY: terraform-init
terraform-init:
	terraform init $(AWS_TERRAFORM_FLAGS)

.PHONY: terraform-validate
terraform-validate:
	terraform validate

.PHONY: terraform-plan
terraform-plan:
	terraform plan $(AWS_TERRAFORM_FLAGS)

.PHONY: terraform-apply
terraform-apply:
	terraform apply $(AWS_TERRAFORM_FLAGS) -auto-approve

.PHONY: aws-destroy
terraform-destroy:
	terraform destroy $(AWS_TERRAFORM_FLAGS) -force
