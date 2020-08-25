variable "region" {
  default = "us-west-2"
  description = "AWS region"
}

variable "vpc_id" {
  default = ""
  description = "Override instad of using the default VPC id"
}

variable "subnet_id" {
  default = ""
  description = "Override instad of using a randomly chosen subvnet"
}

variable "key_name" {
  default = ""
  description = "Set if you need SSH access"
}

variable "app_name" {
  default = "you-speak-yoda"
  description = "Sets the (tag) name of the instance"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Set the default instance type"
}

# Don't define this in your tfvars file for security
# Instead, define it via the `TF_VAR_doppler_service_token` env var when calling `terraform apply`
variable "doppler_service_token" {
  default = ""
  description = "Doppler service token - https://docs.doppler.com/docs/enclave-service-tokens"
}
