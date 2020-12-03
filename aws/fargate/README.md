# Deploy to Fargate using Terraform and Doppler

This solution uses Doppler to supply the Terraform variables required to deploy the YodaSpeak container on Fargate.

## Prerequisites

- Have a Doppler config with the required Terraform variables (see the `sample.env` file for a starting point).
- The IAM user used for Terraform should have the policies `AmazonECS_FullAccess` and `IAMFullAccess` attached (you may also need a policy for creating the CloudWatch log group).
- If the container will get the Doppler service token via AWS Param Store or Secrets Manager, create the relevant resource with a name of `/yodaspeak/production/doppler-token`.

## Design

This deployment is kept as simple as possible as it's only for testing using Doppler with Fargate and Secrets Manager and Parameter Store so as a result:

- There is no load balancer
- There is only one instance of the container
- The container listens on port `8080` and `8443` (unless changed) which means you access the container at, for example `http://{$ip_address}:8080/`
- It uses CloudWatch logs

## Choosing how the `DOPPLER_TOKEN` environment variable is set for the container

You can choose which option to use by altering `main.tf` to select which task definition file to choose for the `aws_ecs_task_definition` resource.

## Usage

- Initialize Terraform: `doppler run -- make terraform-init`
- Terraform plan: `doppler run -- make terraform-plan`
- Terraform apply: `doppler run -- make terraform-apply`
- Terraform destory: `doppler run -- make terraform-destroy`
- Get task (container) status: `doppler run -- task-status`
