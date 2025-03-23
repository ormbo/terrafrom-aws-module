################################################################################
# Storage Gateway
################################################################################

locals {
  create_smb_active_directory_settings = (var.join_smb_domain == true && length(var.domain_controllers) > 0 && length(var.domain_name) > 0 && length(var.domain_password) > 0 && length(var.domain_username) > 0)
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*"
}

resource "aws_ssm_parameter" "smb_guest_password" {
  name = "/swg/smb_guest_password"
  type = "SecureString"
  value = random_password.password.result
  tags = var.tags
  
}

resource "aws_storagegateway_gateway" "storagegateway" {
  gateway_name              = var.storagegateway_name
  gateway_timezone          = var.timezone
  gateway_type              = var.gateway_type
  gateway_vpc_endpoint      = "storagegateway.${data.aws_region.aws_region.name}.amazonaws.com"
  activation_key            = data.aws_ssm_parameter.activation_key.value
  cloudwatch_log_group_arn  = var.cloudwatch_logs ? aws_cloudwatch_log_group.log_group_sgw[0].arn : null
  smb_guest_password        = random_password.password.result

    dynamic "smb_active_directory_settings" {
    for_each = local.create_smb_active_directory_settings == true ? [1] : []

    content {

      # Required inputs
      domain_name = var.domain_name
      password    = var.domain_password
      username    = var.domain_username

      # Optional inputs
      domain_controllers  = var.domain_controllers
      timeout_in_seconds  = var.timeout_in_seconds >= 0 ? var.timeout_in_seconds : null
      organizational_unit = length(var.organizational_unit) > 0 ? var.organizational_unit : null
    }
    }
  tags = merge(var.tags, {
    Name = var.storagegateway_name
  },)
  depends_on            = [ data.aws_ssm_parameter.activation_key ] 
  lifecycle {
    ignore_changes = [
      activation_key,
    ]
  }
}

resource "aws_storagegateway_cache" "example" {
  disk_id     = data.aws_storagegateway_local_disk.test.disk_id
  gateway_arn = aws_storagegateway_gateway.storagegateway.arn
  lifecycle {
    ignore_changes = [
      disk_id]
  }
}  

data "aws_storagegateway_local_disk" "test" {
  disk_node   = var.device_name
  gateway_arn = aws_storagegateway_gateway.storagegateway.arn
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}
data "aws_ssm_parameter" "activation_key" {
  name        = "/sgw/activation_key"

  depends_on = [time_sleep.wait_30_seconds] 
}

data "aws_region" "aws_region" {}

resource "aws_cloudwatch_log_group" "log_group_sgw" {
  count = var.cloudwatch_logs ? 1 : 0
  name = "Cloud-Watch-Storage-Gateway-${var.storagegateway_name}"
  tags = var.tags
}