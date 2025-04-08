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
variable "vpc_id" {
    type = string
    description = "vpc id"
  
}
variable "security_group_name" {
    type = string
    default = "glue-security-group"
}
variable "tags" {
    type = map(string)
}
variable "attach_policies_for_integrations" {
  description = "Whether to attach AWS Service policies to IAM role"
  type        = bool
  default     = true
}

variable "service_integrations" {
  description = "Map of AWS service integrations to allow in IAM role policy"
  type        = any
  default     = {}
}