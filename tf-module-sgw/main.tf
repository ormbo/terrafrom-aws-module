
resource "aws_storagegateway_gateway" "storagegateway" {
  gateway_name          = var.storagegateway_name
  gateway_timezone      = var.timezone
  gateway_type          = var.gateway_type
  activation_key        =  data.aws_ssm_parameter.activation_key.value

  tags = merge(var.tags, {
    Name = var.storagegateway_name
  },)
  depends_on            = [ data.aws_ssm_parameter.activation_key ] 
}

resource "aws_storagegateway_cache" "example" {
  disk_id     = data.aws_storagegateway_local_disk.test.disk_id
  gateway_arn = aws_storagegateway_gateway.storagegateway.arn
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