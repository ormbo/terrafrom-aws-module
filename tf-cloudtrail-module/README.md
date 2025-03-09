# Cloud Trail of Changes in s3 bucket

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.90.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3-bucket-CloudTrail-Logs"></a> [s3-bucket-CloudTrail-Logs](#module\_s3-bucket-CloudTrail-Logs) | terraform-aws-modules/s3-bucket/aws | 4.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.cloudtrail-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.s3-cloud-watch-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cloudtrail_name"></a> [aws\_cloudtrail\_name](#input\_aws\_cloudtrail\_name) | Name of the Cloud Trail | `string` | n/a | yes |
| <a name="input_bucket_list_arn"></a> [bucket\_list\_arn](#input\_bucket\_list\_arn) | The list of arn bucket to log if there is an put or delete | `list(string)` | n/a | yes |
| <a name="input_enable_cloudWatch_logs"></a> [enable\_cloudWatch\_logs](#input\_enable\_cloudWatch\_logs) | Enable Cloud Watch logs | `bool` | `false` | no |
| <a name="input_s3_bucket_logs_name"></a> [s3\_bucket\_logs\_name](#input\_s3\_bucket\_logs\_name) | The name of the logging s3 bucket | `string` | `null` | no |
| <a name="input_use_existing_s3"></a> [use\_existing\_s3](#input\_use\_existing\_s3) | Create new s3 for logging or use existing one | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->