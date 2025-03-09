##############################
#    General resource        #
##############################
resource "random_string" "random" {
  length           = 4
  special          = false
}
###################################################
# Create IAM Policy for s3 bucket script           #
###################################################

# resource "aws_iam_policy" "policy-s3-script" {
#     name = "S3-Policy-bucket-script"
#     policy = templatefile("modules/tf-module-glue/Policy/S3Policy.json", {S3Arn=module.s3-bucket.s3_bucket_arn})
# }
# resource "aws_iam_role_policy_attachment" "s3_policies-script" {
#   role       = "Glue-iam-role-terraform-module"
#   policy_arn = aws_iam_policy.policy-s3-script.arn
# }

###################################################
# Create IAM Policy for s3 bucket target          #
###################################################

# resource "aws_iam_policy" "policy-s3-target" {
#     name = "S3-Policy-bucket-target"
#     policy = templatefile("modules/tf-module-glue/Policy/S3Policy.json", {S3Arn=var.target_bucket_arn})
# }
# resource "aws_iam_role_policy_attachment" "s3_policies-target" {
#   role       = "Glue-iam-role-terraform-module"
#   policy_arn = aws_iam_policy.policy-s3-target.arn
# }

resource "aws_s3_object" "object" {
    bucket = var.s3_bucket_script
    key    = "scripts/script-${random_string.random.id}.py"
    source = var.local_script_path
    etag = filemd5(var.local_script_path)
}

  resource "aws_glue_job" "aws_glue_job" {
    name                      = var.job_name
    description               = var.job_description
    connections               = var.connections
    default_arguments         = merge(var.default_arguments,var.additional_arguments)
    non_overridable_arguments = var.non_overridable_arguments
    glue_version              = var.glue_version
    timeout                   = var.timeout
    number_of_workers         = var.number_of_workers
    worker_type               = var.worker_type
    max_capacity              = var.max_capacity
    role_arn                  = var.role_arn
    security_configuration    = var.security_configuration
    max_retries               = var.max_retries

    command {
      name            = try(var.command.name, null)
      python_version  = try(var.command.python_version, null)
      script_location = "s3://${var.s3_bucket_script}/${aws_s3_object.object.key}"
    }
}
