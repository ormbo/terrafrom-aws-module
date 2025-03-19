output "public_ip" {
  value       = try(aws_eip.ip[0].public_ip, aws_instance.ec2_sgw.private_ip)
  description = "The Public IP address of the created Elastic IP."
  sensitive   = true
}

output "private_ip" {
  value       = aws_instance.ec2_sgw.private_ip
  description = "The Private IP address of the Storage Gateway on EC2"
}

output "disk_id" {
  value = aws_volume_attachment.ebs_volume.id
}
output "volume_id" {
  value = aws_volume_attachment.ebs_volume.volume_id
}
output "device_name" {
  value = aws_volume_attachment.ebs_volume.device_name
}
