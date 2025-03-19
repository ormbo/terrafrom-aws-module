
data "aws_availability_zones" "available" {}



module "aws_glue_security" {
    source =  "../../../terrafrom-aws-module/tf-module-glue-security"

    vpc_id                  =   "vpc-06e7dd7eccec7a493"
    glue_iam_role_name      =   "glue-iam-role-terraform-module"
    additional_iam_policy   =   ["arn:aws:iam::aws:policy/SecretsManagerReadWrite"]
}

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

module "create_sgw" {
  source = "../../../terrafrom-aws-module/tf-module-sgw"

  storagegateway_name = "test"
  gateway_type        = "FILE_S3"
  timezone            = "GMT+2:00"
  disk_id             = module.ec2_sgw.disk_id
  device_name         = module.ec2_sgw.device_name
  depends_on = [ module.ec2_sgw]
  
}
