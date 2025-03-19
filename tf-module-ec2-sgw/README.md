 
 
```bash
 module "ec2_sgw" {
   source     = "../../../terrafrom-aws-module/tf-module-ec2-sgw"
   name                               = "ec2-storage-gateway" 
   availability_zone                  = data.aws_availability_zones.available.names[0] 
   subnet_id                          = "subnet-0f223283350d92e03"
   ingress_cidr_block_activation      = "10.0.1.0/28"
   storagegateway_name                = "Test-Storage-Gateway"
   ssh_key_name                       = "storage-gateway"
   gateway_type                       = "FILE_S3"
   create_vpc_endpoint                = true
   create_security_group              = true
   create_vpc_endpoint_sg             = true 
   vpc_id                             = "vpc-06e7dd7eccec7a493"
   timezone                           = "GMT+2:00"
 }
```