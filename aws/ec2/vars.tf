variable "git_sha" {
  description = "Git hash"
}

variable "region" {
  default = "us-west-2"
  description = "AWS region"
}

variable "vpc_id" {
  description = "Override instad of using the default VPC id"
}

variable "subnet_id" {
  description = "Override instad of using a randomly chosen subvnet"
}

variable "key_name" {
  description = "Set if you need SSH access"
}

variable "app_name" {
  default = "yodaspeak"
  description = "Sets the (tag) name of the instance"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Set the default instance type"
}

variable "doppler_service_token" {
  description = "Doppler service token - https://docs.doppler.com/docs/enclave-service-tokens"
}

variable "cloudflare_email" {
  description = "Cloudflare "
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone id"
}
