variable "optional_tags" {
  type = map(string)
  default = {}
}
variable "subnet_ids" {
  type = list(string)
  description = "Subnet groupe for redshift"
  
}
variable "manage_master_password" {
  type = bool
  description = "Use secret manager"
  default = true
}
variable "cluster_name" {
  type = string
  description = "Name of the cluster"
}
variable "node_type" {
  type = string
  default = "ra3.4xlarge"
}
variable "cluster_type" {
  type = string
  default = "single-node"
}
variable "master_username" {
  type = string
  default = "redshiftadmin"
}
variable "master_password" {
  type = string
  default = ""
}
variable "database_name" {
  type = string
  default = "dev"
}
variable "vpc_id" {
  type = string
  
}
variable "create_glue_connection" {
  type = bool
}

variable "create_catalog_db" {
  type =  bool
}
variable "create_crawler" {
    type = bool
}
variable "port" {
  type = number
  default = 5439
}

variable "glue_iam_role_name" {
  type = string
  default = ""
}
variable "glue_security_group_name" {
  type = string
  default = ""
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "iam_roles" {
    type = list(string)
    default = [  ]
}