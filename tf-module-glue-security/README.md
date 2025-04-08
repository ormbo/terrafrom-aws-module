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
| [aws_iam_policy.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.glue_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.glue_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.glue-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_iam_policy"></a> [additional\_iam\_policy](#input\_additional\_iam\_policy) | Additional policies for IAM glue role | `list(string)` | `[]` | no |
| <a name="input_attach_policies_for_integrations"></a> [attach\_policies\_for\_integrations](#input\_attach\_policies\_for\_integrations) | Whether to attach AWS Service policies to IAM role | `bool` | `true` | no |
| <a name="input_base_policies_iam_role_glue"></a> [base\_policies\_iam\_role\_glue](#input\_base\_policies\_iam\_role\_glue) | Base policies for IAM glue role, Fulle access: S3, Secret Manager and all the AWS glue services | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"<br/>]</pre> | no |
| <a name="input_glue_iam_role_name"></a> [glue\_iam\_role\_name](#input\_glue\_iam\_role\_name) | AWS glue IAM role | `string` | `"Glue-iam-role-terraform-module"` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | n/a | `string` | `"glue-security-group"` | no |
| <a name="input_service_integrations"></a> [service\_integrations](#input\_service\_integrations) | Map of AWS service integrations to allow in IAM role policy | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_glue-security-group-name"></a> [glue-security-group-name](#output\_glue-security-group-name) | n/a |
| <a name="output_glue_security_group_id"></a> [glue\_security\_group\_id](#output\_glue\_security\_group\_id) | n/a |
| <a name="output_iam-role-glue-arn"></a> [iam-role-glue-arn](#output\_iam-role-glue-arn) | n/a |
| <a name="output_iam-role-glue-name"></a> [iam-role-glue-name](#output\_iam-role-glue-name) | n/a |
<!-- END_TF_DOCS -->