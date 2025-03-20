variable "storagegateway_name" {
    type = string
}
variable "gateway_type" {
    type = string
}
variable "join_smb_domain" {
  type        = bool
  sensitive   = false
  default     = false
  description = "Setting for controlling whether to join the Storage gateway to an Active Directory (AD) domain for Server Message Block (SMB) file shares. Variables domain_controllers, domain_name, password and username should also be specified to join AD domain."
}
variable "domain_name" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The name of the domain that you want the gateway to join"
}

variable "domain_username" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The user name for the service account on your self-managed AD domain that SGW use to join to your AD domain"
}

variable "domain_password" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The password for the service account on your self-managed AD domain that SGW will use to join to your AD domain"
}
variable "timeout_in_seconds" {
  type        = number
  sensitive   = false
  default     = -1
  description = "Specifies the time in seconds, in which the JoinDomain operation must complete. The default is 20 seconds."
}
variable "domain_controllers" {
  default     = []
  type        = list(any)
  sensitive   = true
  description = "List of IPv4 addresses, NetBIOS names, or host names of your domain server. If you need to specify the port number include it after the colon (“:”). For example, mydc.mydomain.com:389."
}
variable "organizational_unit" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The organizational unit (OU) is a container in an Active Directory that can hold users, groups, computers, and other OUs and this parameter specifies the OU that the gateway will join within the AD domain."
}
variable "timezone" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "device_name" {
  type = string
  
}
variable "cloudwatch_logs" {
  type = bool
  default = false
}