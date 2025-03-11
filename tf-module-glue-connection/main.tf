
##############################
# Attach Additional Policies #
##############################
# resource "aws_iam_role_policy_attachment" "additional_policies" {
#   count      = length(var.additional_iam_policy)
#   role       = aws_iam_role.glue_role.name
#   policy_arn = var.additional_iam_policy[count.index]
# }

###################################################
# Create IAM Policy for Secret Manager Connection #
###################################################

# resource "aws_iam_policy" "policy-secret-manager" {
#     count = var.get_from_secret_manager ? 1 :0
#     name = "SecretManager-Policy-${var.secret_name}"
#     policy = templatefile("modules/tf-module-glue/Policy/SecretManagerPolicy.json", {SecretArn=data.aws_secretsmanager_secret.secret[0].arn})
# }
# resource "aws_iam_role_policy_attachment" "secret_policies" {
#   count = var.get_from_secret_manager ? 1 :0
#   role       = aws_iam_role.glue_role.name
#   policy_arn = aws_iam_policy.policy-secret-manager[0].arn
# }

##############################
# Create AWS Glue Connection #
##############################
resource "aws_glue_connection" "create_connection" {
  name = var.connection_name
  connection_properties = {
    JDBC_CONNECTION_URL = (
      var.data_source == "oracle" ? "jdbc:oracle:thin:@${var.host}:${var.connection_port}/${db_name}" :
      var.data_source == "mysql" ? "jdbc:mysql://${var.host}:${var.connection_port}/${db_name}" :
      var.data_source == "postgresql" ? "jdbc:postgresql://${var.host}:${var.connection_port}/${db_name}" :
      var.data_source == "sqlserver" ? "jdbc:sqlserver://${var.host}:${var.connection_port};databaseName=${db_name}" :
      var.data_source == "redshift" ? "jdbc:redshift://${var.host}:${var.connection_port}/${db_name}" :
      null
    )
    # If using Secrets Manager, use SECRET_ID; otherwise, use USERNAME & PASSWORD
    SECRET_ID = var.get_from_secret_manager ? data.aws_secretsmanager_secret.secret[0].name : null
    USERNAME  = var.get_from_secret_manager ? null : var.db_username
    PASSWORD  = var.get_from_secret_manager ? null : var.db_password
  }

  physical_connection_requirements {
  availability_zone      = var.use_vpc ? data.aws_subnet.subnet.availability_zone : null
  security_group_id_list = var.use_vpc ? var.security_group_id_list : null
  subnet_id              = var.use_vpc ? var.subnet_id : null
  }
}


resource "aws_glue_catalog_database" "database-catalog" {
  name = var.glue_database
  description = "Database Data Catalog"
}

# Fetch the Secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "secret" {
  count = var.get_from_secret_manager ? 1 : 0
  name =  var.secret_name
}

data "aws_subnet" "subnet" {
  id = var.subnet_id  # Pass your subnet ID as a variable or hardcode
}


resource "aws_glue_crawler" "jdbc-crawler-multi-db" {
  name          = "crawler-for-${var.connection_name}"
  role          = var.glue_iam_role_name
  database_name = var.glue_database

  jdbc_target {
      connection_name = aws_glue_connection.create_connection.name
      path            = "${var.db_name}/%"  # Correct way to reference each.value in dynamic block
  }

  depends_on = [aws_glue_connection.create_connection]
}
