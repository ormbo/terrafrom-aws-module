variable "cidr" {
  type        = string
  description = "cidr for vpc"

}
variable "vpc_name" {
  type = string
}
variable "private_subnets" {
  type        = list(string)
  description = "cidr for private subnet"

}
variable "public_subnets" {
  type        = list(string)
  description = "cidr for public subnet"

}
variable "azs-vpc" {
  type        = list(string)
  description = "azs for subnets"

}
variable "tags" {
  type        = map(string)
  description = "tags for description"

}
