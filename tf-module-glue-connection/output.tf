output "database_catalog_name" {
    value = try(aws_glue_catalog_database.database-catalog[0].name, "")
  
}
output "connection_name" {
     value = aws_glue_connection.create_connection.name
}