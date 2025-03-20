
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.optional_tags,
  {
    Name = "Redshift Subnet Group"
  })
}


resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = var.vpc_id

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
  number_of_nodes           = 2
  database_name             = var.database_name
  master_username           = var.master_username
  iam_roles                 = var.iam_roles
  manage_master_password    = true
  publicly_accessible       = false
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  port                      = var.port
  encrypted                 = true
  skip_final_snapshot       = true
  tags                      = var.optional_tags
}

data "aws_secretsmanager_secret" "by-arn" {
  arn = aws_redshift_cluster.redshift_cluster.master_password_secret_arn
}

resource "aws_glue_connection" "create_connection" {
  count = var.create_glue_connection ? 1 : 0
  name = "${aws_redshift_cluster.redshift_cluster.id}-connection"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${aws_redshift_cluster.redshift_cluster.dns_name}:${var.port}/${var.database_name}" 
    SECRET_ID = var.manage_master_password ? data.aws_secretsmanager_secret.by-arn.name : null
    USERNAME  = var.manage_master_password ? null : var.master_username
    PASSWORD  = var.manage_master_password ? null : var.master_password
  }

  physical_connection_requirements {
  availability_zone      = data.aws_subnet.subnet.availability_zone
  security_group_id_list = [var.glue_security_group_name]
  subnet_id              = var.subnet_ids[0]
  }
  tags                   = var.tags
}
data "aws_subnet" "subnet" {
  id = var.subnet_ids[0]  # Pass your subnet ID as a variable or hardcode
}

resource "aws_glue_catalog_database" "database-catalog" {
  count = var.create_catalog_db ? 1 : 0
  name = "datacatalog-db-${var.cluster_name}-${var.database_name}"
  description = "Database Data Catalog for ${var.cluster_name}-${var.database_name}"
}


resource "aws_glue_crawler" "jdbc-crawler-multi-db" {
  count = var.create_crawler ? 1 : 0
  name          = "crawler-for-${var.cluster_name}-${var.database_name}"
  role          = var.glue_iam_role_name
  database_name = aws_glue_catalog_database.database-catalog[0].name

  jdbc_target {
      connection_name = aws_glue_connection.create_connection[0].name
      path            = "${var.database_name}/%"  # Correct way to reference each.value in dynamic block
  }

  depends_on = [aws_glue_connection.create_connection]
}
