<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group_sgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ssm_parameter.smb_guest_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_storagegateway_cache.storagegateway_cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_cache) | resource |
| [aws_storagegateway_gateway.storagegateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_gateway) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_region.aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.activation_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_storagegateway_local_disk.storagegateway_local_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/storagegateway_local_disk) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_logs"></a> [cloudwatch\_logs](#input\_cloudwatch\_logs) | n/a | `bool` | `false` | no |
| <a name="input_device_name"></a> [device\_name](#input\_device\_name) | n/a | `string` | n/a | yes |
| <a name="input_domain_controllers"></a> [domain\_controllers](#input\_domain\_controllers) | List of IPv4 addresses, NetBIOS names, or host names of your domain server. If you need to specify the port number include it after the colon (“:”). For example, mydc.mydomain.com:389. | `list(any)` | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the domain that you want the gateway to join | `string` | `""` | no |
| <a name="input_domain_password"></a> [domain\_password](#input\_domain\_password) | The password for the service account on your self-managed AD domain that SGW will use to join to your AD domain | `string` | `""` | no |
| <a name="input_domain_username"></a> [domain\_username](#input\_domain\_username) | The user name for the service account on your self-managed AD domain that SGW use to join to your AD domain | `string` | `""` | no |
| <a name="input_gateway_type"></a> [gateway\_type](#input\_gateway\_type) | n/a | `string` | n/a | yes |
| <a name="input_join_smb_domain"></a> [join\_smb\_domain](#input\_join\_smb\_domain) | Setting for controlling whether to join the Storage gateway to an Active Directory (AD) domain for Server Message Block (SMB) file shares. Variables domain\_controllers, domain\_name, password and username should also be specified to join AD domain. | `bool` | `false` | no |
| <a name="input_organizational_unit"></a> [organizational\_unit](#input\_organizational\_unit) | The organizational unit (OU) is a container in an Active Directory that can hold users, groups, computers, and other OUs and this parameter specifies the OU that the gateway will join within the AD domain. | `string` | `""` | no |
| <a name="input_storagegateway_name"></a> [storagegateway\_name](#input\_storagegateway\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_timeout_in_seconds"></a> [timeout\_in\_seconds](#input\_timeout\_in\_seconds) | Specifies the time in seconds, in which the JoinDomain operation must complete. The default is 20 seconds. | `number` | `-1` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_activation_key"></a> [activation\_key](#output\_activation\_key) | } |
| <a name="output_disk_id"></a> [disk\_id](#output\_disk\_id) | n/a |
| <a name="output_gateway_arn"></a> [gateway\_arn](#output\_gateway\_arn) | n/a |
| <a name="output_local_disk"></a> [local\_disk](#output\_local\_disk) | n/a |
<!-- END_TF_DOCS -->