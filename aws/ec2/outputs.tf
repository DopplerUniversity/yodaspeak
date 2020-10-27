output "instance_id" {
  value = aws_instance.this.id
}
output "aws_instance_url" {
  value = "https://${aws_instance.this.public_dns}/"
}

output "aws_instance_ip" {
  value = aws_instance.this.public_ip
}

output "aws_instance_hostname" {
  value = aws_instance.this.public_dns
}

output "app_url" {
  value = "https://${cloudflare_record.this.hostname}/"
}

output "ssh" {
  value = "ssh ec2-user@${aws_instance.this.public_dns}"
}
