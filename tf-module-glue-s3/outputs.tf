output "crawler_name_s3" {
    value = try(aws_glue_crawler.jdbc-crawler-s3[0].name, "")
}
output "crawler_arn" {
    value = try(aws_glue_crawler.jdbc-crawler-s3[0].arn, "")
}
output "catalog_db_name" {
    value = try(aws_glue_catalog_database.catalog_database_s3[0].name, "")
  
}