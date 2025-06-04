module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"
  name            = var.vpc_name
  cidr            = var.cidr
  azs             = var.azs-vpc
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = var.tags
}

module "endpoints" {
    source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
    version = "5.19.0"

    vpc_id                      =   module.vpc.vpc_id
    create_security_group       =   true
    security_group_name         =   "SandBox-Endpoint-SG"
    endpoints                   =   {
        endpoint-secretsmanager =   {
            service             =   "secretsmanager"
            private_dns_enabled =   true
            subnet_ids          =   module.vpc.private_subnets
            },  
        endpoint-s3             =   {
            service             =   "s3"
            service_type        =   "Gateway"
            route_table_ids     =   module.vpc.private_route_table_ids
            },
    }
    tags                        =   var.tags
    depends_on                  =   [module.vpc]
}


resource "aws_security_group" "security_group_ec2" {
    name        = "SandBox-SG"
    description = "Allow inbound RDP traffic"
    vpc_id      = module.vpc.vpc_id

    ingress {
        description = "Allow inbound RDP traffic"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
        description = "Allow inbound RDP traffic"
        from_port   = 5439
        to_port     = 5439
        protocol    = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
        description = "Allow inbound RDP traffic"
        from_port   = -1
        to_port     = -1
        protocol    = "ICMP"
        cidr_blocks      = ["0.0.0.0/0"]
  }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  tags =merge(var.tags, {
    Name = "SandBox-SG"
  }) 
}
