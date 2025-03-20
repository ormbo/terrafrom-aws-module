
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = ["subnet-0abd11dc3569a4137"]

  tags = merge(var.optional_tags,
  {
    Name = "Redshift Subnet Group"
  })
}


resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = "vpc-0697076edef740883"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.optional_tags,
    {
    Name = "Redshift Security Group"
    })
}


resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier        = var.cluster_name
  node_type                 = var.node_type
  cluster_type              = var.cluster_type
  number_of_nodes           = 1
  database_name             = var.database_name
  master_username           = var.master_username
  manage_master_password    = true
  publicly_accessible       = false
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  availability_zone         = data.aws_availability_zone.availability_zone.name
  encrypted                 = true
  skip_final_snapshot       = true
  tags                      = var.optional_tags
}

data "aws_availability_zone" "availability_zone" {}