<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.database-catalog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_connection.create_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection) | resource |
| [aws_glue_crawler.jdbc-crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |
| [aws_iam_policy.policy-secret-manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.glue_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.glue_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secret_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.glue-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_iam_policy"></a> [additional\_iam\_policy](#input\_additional\_iam\_policy) | Additional policies for IAM glue role | `list(string)` | `[]` | no |
| <a name="input_base_policies_iam_role_glue"></a> [base\_policies\_iam\_role\_glue](#input\_base\_policies\_iam\_role\_glue) | Base policies for IAM glue role, Fulle access: S3, Secret Manager and all the AWS glue services | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"<br/>]</pre> | no |
| <a name="input_connection_name"></a> [connection\_name](#input\_connection\_name) | The connection name | `string` | n/a | yes |
| <a name="input_connection_port"></a> [connection\_port](#input\_connection\_port) | The connection port | `string` | n/a | yes |
| <a name="input_data_source"></a> [data\_source](#input\_data\_source) | The data source e.g mysql | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The url of the DB | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | password | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | username | `string` | `null` | no |
| <a name="input_get_from_secret_manager"></a> [get\_from\_secret\_manager](#input\_get\_from\_secret\_manager) | Get the username and password form Secret Manager (optional) | `bool` | `false` | no |
| <a name="input_glue_database"></a> [glue\_database](#input\_glue\_database) | AWS glue database | `string` | `null` | no |
| <a name="input_glue_iam_role_name"></a> [glue\_iam\_role\_name](#input\_glue\_iam\_role\_name) | AWS glue IAM role | `string` | `"Glue-iam-role-terraform-module"` | no |
| <a name="input_host"></a> [host](#input\_host) | The url of the DB | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Get the username and password form Secret Manager (optional) | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Security group for connection (optional) | `list(string)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet\_id for connection (optional) | `string` | `null` | no |
| <a name="input_use_vpc"></a> [use\_vpc](#input\_use\_vpc) | Set to true if Glue needs to run inside a VPC (optional) | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | n/a |
| <a name="output_iam-role-arn"></a> [iam-role-arn](#output\_iam-role-arn) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->