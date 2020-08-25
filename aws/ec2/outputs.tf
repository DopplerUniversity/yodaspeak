output "instance_id" {
  value = "${aws_instance.this.id}"
}
output "aws_instance_url" {
  value = "${format("https://%s/", aws_instance.this.public_dns)}"
}

output "aws_instance_ip" {
  value = "${aws_instance.this.public_ip}"
}

output "app_url" {
  value = "https://${cloudflare_record.this.hostname}/"
}

output "ssh" {
  value = "${format("ssh ec2-user@%s", aws_instance.this.public_dns)}"
}
