<!-- BEGIN_TF_DOCS -->
## Requirements

## Examples: 
```bash
module "aws_glue_job" {
    source = "././modules/tf-module-glue-job"

    for_each = var.data_jobs
    job_name                = each.key
    s3_bucket_script        = module.aws_glue_s3.s3-job-bucket-name
    local_script_path       = each.value.local_script_path 
    worker_type             = each.value.worker_type
    number_of_workers       = each.value.number_of_workers
    max_retries             = each.value.max_retries
    additional_arguments = {
    "--JOB_NAME"       = each.key
    "--DATABASE_NAME"  = each.value.db_catalog_name
    "--S3_OUTPUT"      = "s3://${module.aws_glue_s3.s3-data-bucket-name}/"
    "--REGION_NAME"    = var.region
    "--TempDir"        = "s3://${module.aws_glue_s3.s3-data-bucket-name}/temp/"
    }

    command = {
        python_version  = 3
    }
    role_arn                = module.aws_glue_security.iam-role-glue-arn
    depends_on              = [ module.aws_glue_s3 ]
}
```

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | terraform-aws-modules/s3-bucket/aws | 4.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.etl-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_job.aws_glue_job](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |
| [aws_iam_policy.policy-s3-script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.policy-s3-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.s3_policies-script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_policies-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_object.object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_arguments"></a> [additional\_arguments](#input\_additional\_arguments) | Add more arguments for the ETL job | `map(string)` | `{}` | no |
| <a name="input_command"></a> [command](#input\_command) | The command of the job. | `map(any)` | n/a | yes |
| <a name="input_connections"></a> [connections](#input\_connections) | The list of connections used for this job. | `list(string)` | `null` | no |
| <a name="input_default_arguments"></a> [default\_arguments](#input\_default\_arguments) | The map of default arguments for the job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes. | `map(string)` | <pre>{<br/>  "--enable-continuous-cloudwatch-log": "true",<br/>  "--enable-continuous-log-filter": "true",<br/>  "--enable-metrics": "true",<br/>  "--enable-observability-metrics": "true",<br/>  "--job-language": "python"<br/>}</pre> | no |
| <a name="input_glue_version"></a> [glue\_version](#input\_glue\_version) | The version of Glue to use. | `string` | `"4.0"` | no |
| <a name="input_job_description"></a> [job\_description](#input\_job\_description) | Glue job description. | `string` | `"Glue ETL job"` | no |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | Glue job name. If not provided, the name will be generated from the context. | `string` | `null` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The maximum number of AWS Glue data processing units (DPUs) that can be allocated when the job runs. Required when `pythonshell` is set, accept either 0.0625 or 1.0. Use `number_of_workers` and `worker_type` arguments instead with `glue_version` 2.0 and above. | `number` | `null` | no |
| <a name="input_max_retries"></a> [max\_retries](#input\_max\_retries) | The maximum number of times to retry the job if it fails. | `number` | `null` | no |
| <a name="input_non_overridable_arguments"></a> [non\_overridable\_arguments](#input\_non\_overridable\_arguments) | Non-overridable arguments for this job, specified as name-value pairs. | `map(string)` | `null` | no |
| <a name="input_number_of_workers"></a> [number\_of\_workers](#input\_number\_of\_workers) | The number of workers of a defined `worker_type` that are allocated when a job runs. | `number` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role associated with this job. | `string` | n/a | yes |
| <a name="input_security_configuration"></a> [security\_configuration](#input\_security\_configuration) | The name of the Security Configuration to be associated with the job. | `string` | `null` | no |
| <a name="input_target_bucket_arn"></a> [target\_bucket\_arn](#input\_target\_bucket\_arn) | The s3 bucket to store the result from the etl job | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The job timeout in minutes. The default is 2880 minutes (48 hours) for `glueetl` and `pythonshell` jobs, and `null` (unlimited) for `gluestreaming` jobs. | `number` | `2880` | no |
| <a name="input_worker_type"></a> [worker\_type](#input\_worker\_type) | The type of predefined worker that is allocated when a job runs. Accepts a value of `Standard`, `G.1X`, or `G.2X`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_path-to-script-s3"></a> [path-to-script-s3](#output\_path-to-script-s3) | n/a |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | n/a |
<!-- END_TF_DOCS -->