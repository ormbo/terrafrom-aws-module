variable "storagegateway_name" {
    type = string
}
variable "gateway_type" {
    type = string
}
variable "timezone" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "disk_id" {
  type = string
  
}
variable "device_name" {
  type = string
  
}