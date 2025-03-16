
data "aws_availability_zones" "available" {}


module "ec2_sgw" {
  source     = "../../../terrafrom-aws-module/tf-module-ec2-sgw"

  name                               = "ec2-storage-gateway" 
  availability_zone                  = data.aws_availability_zones.available.names[0] 
  subnet_id                          = "subnet-0f223283350d92e03"
  ingress_cidr_block_activation      = "10.0.1.0/28"
  ssh_key_name                       = "storage-gateway"
  create_vpc_endpoint                = true
  create_security_group              = true
  create_vpc_endpoint_sg             = true 
  vpc_id                             = "vpc-06e7dd7eccec7a493"
  timezone                           = "GMT+2:00"
}

resource "aws_storagegateway_gateway" "example" {
  gateway_name          = "example-gateway"
  gateway_timezone      = "GMT"
  gateway_type          = "FILE_S3"
  activation_key        = "CRJKK-0M4Q1-0GN33-EHBB3-1KBFE"  # Initially, leave it empty for creation

  tags = {
    Name = "example-storage-gateway"
  }
}
resource "aws_storagegateway_cache" "example" {
  disk_id     = data.aws_storagegateway_local_disk.example.id
  gateway_arn = aws_storagegateway_gateway.example.arn
}