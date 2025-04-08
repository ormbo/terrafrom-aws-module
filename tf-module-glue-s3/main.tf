

##############################
#  Glue datacatalog database s3            
##############################

resource "aws_glue_catalog_database" "catalog_database_s3" {
  count = var.create_db_catalog ? 1 : 0 
  name = "s3-database-catalog-${var.bucket_name}"
  description = "Glue database catalog for s3 raw data layer"
  tags = var.tags
}

##############################
#       Glue crawler s3            
##############################

resource "aws_glue_crawler" "jdbc-crawler-s3" {
  count         = var.create_crawler ? 1 : 0
  database_name = aws_glue_catalog_database.catalog_database_s3[0].name
  name          = "crawler-for-${var.bucket_name}"
  role          = var.glue_iam_role_name
  
  s3_target {
    path = var.specific_folder ? ("s3://${var.bucket_name}/${var.folder_name}") : ("s3://${var.bucket_name}/")
  }
  tags = var.tags
}



