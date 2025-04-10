# output "activation_key" {
#     value = local.activation_key
  
# }
output "activation_key" {
    value = data.aws_ssm_parameter.activation_key.value
    sensitive = true
  
}
output "local_disk" {
  value = data.aws_storagegateway_local_disk.storagegateway_local_disk
}

output "disk_id" {
  value = aws_storagegateway_cache.storagegateway_cache.disk_id
}
output "gateway_arn" {
    value = aws_storagegateway_gateway.storagegateway.arn
}