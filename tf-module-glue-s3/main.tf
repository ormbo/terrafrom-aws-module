

##############################
#       Create s3  for data  #
##############################
module "s3-bucket-data" {
    source            = "terraform-aws-modules/s3-bucket/aws"
    version           = "4.5.0"

    bucket = "s3-raw-data-layer"
    acl    = "private"
    control_object_ownership = true
    object_ownership         = "ObjectWriter"
    versioning = {
        enabled = true
    }
}

##############################
#  Glue datacatalog database s3            
##############################

resource "aws_glue_catalog_database" "catalog_database_s3" {
  name = "s3-database-catalog-${module.s3-bucket-data.s3_bucket_id}"
  description = "Glue database catalog for s3 raw data layer"
}

##############################
# Create AWS Glue ETL job #
##############################
#Source to store the aws glue script
module "s3-bucket-job" {
    source            = "terraform-aws-modules/s3-bucket/aws"
    version           = "4.5.0"

    bucket = "aws-glue-etl-script-s3"
    acl    = "private"
    control_object_ownership = true
    object_ownership         = "ObjectWriter"
    versioning = {
        enabled = true
    }
}

##############################
#       Glue crawler s3            
##############################

resource "aws_glue_crawler" "jdbc-crawler-s3" {
  database_name = aws_glue_catalog_database.catalog_database_s3.name
  name          = "crawler-for-s3-raw-data-layer"
  role          = var.glue_iam_role_name
  
  s3_target {
    path = "s3://${module.s3-bucket-data.s3_bucket_id}/${var.database_catalog}"
  }
}



