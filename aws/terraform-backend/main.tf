terraform {
  required_version = ">=0.13.0"
}

provider "aws" {
  region = var.region
}

# Use S3 as the Terraform backend
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}
