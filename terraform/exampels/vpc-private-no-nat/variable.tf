############## Global Variable ##############

variable "tags" {
    type        =   map(string)
    description =   "Tags for resources"
}
variable "region" {
    type        =   string
    description =   "resource region"
}

############## VPC Variable ##############

variable "vpc-name" {
    type = string
    description = "Name of VPC"
}

variable "cidr" {
    type = string
    description = "cidr vpc"
}

variable "azs" {
  type = list(string)
  description = "azs for the vpc"
}

variable "private_subnets" {
    type = list(string)
    description = "cidr for private subnets"
}
