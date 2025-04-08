
variable "create_db_catalog" {
    type = bool
}
variable "create_crawler" {
  type = bool
}
variable "bucket_name" {
    type = string
    description = "The name of the exist s3 to data layer"
    default = null
}
variable "specific_folder" {
  type = bool
  description = "The crawler run in specific folder in the bucket"
  default = false
}
variable "folder_name" {
  description = "Folder path must end with a '/'"
  type        = string
  default = ""

  validation {
    condition     = can(regex(".*/$", var.folder_name))
    error_message = "The folder path must end with a '/'."
  }
}
variable "glue_iam_role_name" {
    type = string
    description = "AWS glue IAM role"
    default = "glue-iam-role-terraform-module"
}

variable "list_glue_database_catalog" {
    type = list(string)
    description = "The database catalog name"
    default = []
}
variable "tags" {
  type = map(string)
  default = {}
}

