variable "aws_cloudtrail_name" {
    type = string
    description = "Name of the Cloud Trail"
}

variable "use_existing_s3" {
    type = bool
    description = "Create new s3 for logging or use existing one"
    default = false
}

variable "s3_bucket_logs_name" {
    type = string
    description = "The name of the logging s3 bucket"
    default = null
}

variable "enable_cloudWatch_logs" {
    type = bool
    description = "Enable Cloud Watch logs"
    default = false
}
variable "bucket_list_arn" {
    type = list(string)
    description = "The list of arn bucket to log if there is an put or delete"
  
}