variable "share_name" {
  description = "Name of the smb file share"
  type        = string
}

variable "gateway_arn" {
  type        = string
  description = "Storage Gateway ARN"
}

variable "create_bucket" {
  type = bool
  default = false
}
variable "authentication" {
  type = string
  description = "ActiveDirectory or GuestAccess"  
}
variable "bucket_name" {
  type = string
  description = "The name of the bucket that we want to create for storage gateway"
  default = ""
}
variable "bucket_arn" {
  type        = string
  description = "Storage Gateway ARN"
  default = ""
}

variable "storage_class" {
  type        = string
  description = "Storage class for SMB file share. Valid options are S3_STANDARD | S3_INTELLIGENT_TIERING | S3_STANDARD_IA | S3_ONEZONE_IA"
  default     = "S3_STANDARD"
  validation {
    condition     = contains(["S3_STANDARD", "S3_INTELLIGENT_TIERING", "S3_STANDARD_IA", "S3_ONEZONE_IA"], var.storage_class)
    error_message = "Incorrect Storage Class. S3_STANDARD | S3_INTELLIGENT_TIERING | S3_STANDARD_IA | S3_ONEZONE_IA"
  }
}

variable "admin_user_list" {
  type        = list(any)
  sensitive   = true
  description = "A list of users in the Active Directory that have admin access to the file share."
  default     = ["Domain Admins"]
}

variable "cache_timeout" {
  type        = number
  description = "Cache stale timeout for automated cache refresh in seconds. Default is set to 1 hour (3600 seconds) can be changed to as low as 5 minutes (300 seconds)"
  default     = "3600"
}

variable "tags" {
  type        = map(any)
  description = "(Optional) Key-value map of resource tags."
  default     = {}
}

variable "kms_encrypted" {
  type        = bool
  description = "(Optional) Boolean value if true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3. Defaults to false"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "(Optional) Amazon Resource Name (ARN) for KMS key used for Amazon S3 server side encryption. This value can only be set when kms_encrypted is true."
  default     = null
}