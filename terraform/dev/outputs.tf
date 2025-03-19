# output "activation_key" {
#   value = module.create_sgw.activation_key
# }
output "activation_key" {
  value = nonsensitive(module.create_sgw.activation_key)
}
output "local_disk" {
  value = module.create_sgw.local_disk
}

output "disk_id" {
  value = module.create_sgw.disk_id
}
output "local_disk_id" {
  value = module.ec2_sgw.device_name
  
}
output "volume_id" {
  value = module.ec2_sgw.volume_id
  
}
