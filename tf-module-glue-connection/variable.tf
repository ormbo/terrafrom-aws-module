variable "connection_name" {
    type = string
    description = "The connection name"
}
variable "host" {
    type = string
    description = "The url of the DB or IP"
}
variable "connection_port" {
    type = string
    description = "The connection port"
}
variable "db_name" {
    type = string
    description = "The list of DB"
}
variable "db_username" {
    type = string
    description = "username"
    default = null
}
variable "db_password" {
    type = string
    description = "password"
    default = null
}
variable "get_from_secret_manager" {
    type = bool
    description = "Get the username and password form Secret Manager"
    default = true
}
variable "secret_name" {
    type = string
    description = "Get the username and password form Secret Manager (optional)"
}
variable "data_source" {
    type = string
    description = "The data source e.g mysql"
}
variable "use_vpc" {
  description = "Set to true if Glue needs to run inside a VPC (optional)"
  type        = bool
  default     = true
}
variable "vpc_id"{
    type = string
    description = "The vpc ID"
    default = null
}
variable "additional_security_group_id" {
    type = string
    description = "Security group for connection (optional)"
    default = null
  
}
variable "subnet_id" {
    type = string
    description = "subnet_id for connection (optional)"
    default = null
}

variable "glue_iam_role_name" {
    type = string
    description = "AWS glue IAM role"
    default = "Glue-iam-role-terraform-module"
}
variable "base_policies_iam_role_glue" {
    type = list(string)
    description = "Base policies for IAM glue role, Fulle access: S3, Secret Manager and all the AWS glue services"
    default = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
}
variable "additional_iam_policy" {
    type = list(string)
    description = "Additional policies for IAM glue role"
    default = []
}
variable "create_catalog_db" {
    type = bool
    description = "Create crawler for the connection?"
    default = false
}
variable "create_crawler" {
    type = bool
    description = "Create crawler for the connection?"
    default = false
}
variable "security_group_id_list" {
    type = list(string)
    description = "List of security group for connection"
  
}
variable "tags" {
    type = map(string)
    description = "Tags"
    default = {}
}