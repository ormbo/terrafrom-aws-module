
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
