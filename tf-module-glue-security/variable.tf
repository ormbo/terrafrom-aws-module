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
