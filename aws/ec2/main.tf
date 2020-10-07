terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {}
    cloudflare = {
      source = "terraform-providers/cloudflare"
    }
  }

  backend "s3" {
    bucket = "you-speak-yoda-terraform"
    key    = "yodaspeak"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.region
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name = "owner-alias"
    values = [
    "amazon"]
  }


  filter {
    name = "name"
    values = [
    "amzn2-ami-hvm*"]
  }

  filter {
    name = "architecture"
    values = [
    "x86_64"]
  }
}

# ------------------------------------------
# NETWORKING
# ------------------------------------------

resource "aws_security_group" "this" {
  name        = "${var.app_name}-sg"
  description = "Allow all inbound traffic on 80 and 443"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.app_name}-sg"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}


# ------------------------------------------
# IAM
# ------------------------------------------

resource "aws_iam_role" "this" {
  name                = "${var.app_name}-role"
  assume_role_policy  = file("${path.module}/resources/iam-policy-instance-assume-role.json")
}

resource "aws_iam_policy" "this" {
  name    = "${var.app_name}-access-policy"
  policy   = file("${path.module}/resources/ec2-role-access-policy.json")
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.app_name}-instance-profile"
  role = aws_iam_role.this.name
}


# ------------------------------------------
# EC2 INSTANCE
# ------------------------------------------

resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
  "${aws_security_group.this.id}"]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.this.name
  user_data                   = templatefile("${path.module}/resources/amazon-linux2.sh", { doppler_service_token = "${var.doppler_service_token}", git_sha = "${var.git_sha}" })

  tags = {
    Name = "${var.app_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "this" {
  zone_id = var.cloudflare_zone_id
  name    = "aws"
  value   = aws_instance.this.public_ip
  type    = "A"
  proxied = true
}
