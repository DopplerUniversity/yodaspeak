variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "app_name" { default = "yodaspeak" }
variable "vpc_id" {}
variable "subnet_id" {}
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "port" { default = 80 }
variable "tls_port" { default = 443 }
variable "doppler_token" {}