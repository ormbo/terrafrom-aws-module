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
| [aws_cloudwatch_log_group.log_group_file_share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.storagegateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach-policy-to-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_storagegateway_smb_file_share.smbshare](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_smb_file_share) | resource |
| [aws_iam_policy_document.S3_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_user_list"></a> [admin\_user\_list](#input\_admin\_user\_list) | A list of users in the Active Directory that have admin access to the file share. | `list(any)` | <pre>[<br/>  "Domain Admins"<br/>]</pre> | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | ActiveDirectory or GuestAccess | `string` | n/a | yes |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | Storage Gateway ARN | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket that we want to create for storage gateway | `string` | `""` | no |
| <a name="input_cache_timeout"></a> [cache\_timeout](#input\_cache\_timeout) | Cache stale timeout for automated cache refresh in seconds. Default is set to 1 hour (3600 seconds) can be changed to as low as 5 minutes (300 seconds) | `number` | `"3600"` | no |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | n/a | `bool` | `false` | no |
| <a name="input_gateway_arn"></a> [gateway\_arn](#input\_gateway\_arn) | Storage Gateway ARN | `string` | n/a | yes |
| <a name="input_kms_encrypted"></a> [kms\_encrypted](#input\_kms\_encrypted) | (Optional) Boolean value if true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3. Defaults to false | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Optional) Amazon Resource Name (ARN) for KMS key used for Amazon S3 server side encryption. This value can only be set when kms\_encrypted is true. | `string` | `null` | no |
| <a name="input_share_name"></a> [share\_name](#input\_share\_name) | Name of the smb file share | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class for SMB file share. Valid options are S3\_STANDARD \| S3\_INTELLIGENT\_TIERING \| S3\_STANDARD\_IA \| S3\_ONEZONE\_IA | `string` | `"S3_STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value map of resource tags. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_smb_share_arn"></a> [smb\_share\_arn](#output\_smb\_share\_arn) | The ARN of the created SMB File Share. |
| <a name="output_smb_share_path"></a> [smb\_share\_path](#output\_smb\_share\_path) | The path of the created SMB File Share. |
<!-- END_TF_DOCS -->