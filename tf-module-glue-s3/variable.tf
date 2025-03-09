variable "glue_database" {
    type = string
    description = "AWS glue database"
    default = null
}
variable "glue_iam_role_name" {
    type = string
    description = "AWS glue IAM role"
    default = "glue-iam-role-terraform-module"
}
variable "database_catalog" {
    type = string
    description = "The database catalog name"
  
}
