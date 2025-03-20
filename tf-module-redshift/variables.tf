variable "optional_tags" {
  type = map(string)
  default = {}
}
variable "subnet_ids" {
  type = list(string)
  description = "Subnet groupe for redshift"
  
}
variable "cluster_name" {
  type = string
  description = "Name of the cluster"
}
variable "node_type" {
  type = string
  default = "ra3.4xlarge "
  
}
variable "cluster_type" {
  type = string
  default = "single-node"
}
variable "master_username" {
  type = string
  default = "redshiftadmin"
  
}
variable "database_name" {
  type = string
  default = "dev"
}
