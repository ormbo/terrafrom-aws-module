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
| [aws_glue_catalog_database.catalog_database_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_crawler.jdbc-crawler-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the exist s3 to data layer | `string` | `null` | no |
| <a name="input_create_crawler"></a> [create\_crawler](#input\_create\_crawler) | n/a | `bool` | n/a | yes |
| <a name="input_create_db_catalog"></a> [create\_db\_catalog](#input\_create\_db\_catalog) | n/a | `bool` | n/a | yes |
| <a name="input_folder_name"></a> [folder\_name](#input\_folder\_name) | Folder path must end with a '/' | `string` | `""` | no |
| <a name="input_glue_iam_role_name"></a> [glue\_iam\_role\_name](#input\_glue\_iam\_role\_name) | AWS glue IAM role | `string` | `"glue-iam-role-terraform-module"` | no |
| <a name="input_list_glue_database_catalog"></a> [list\_glue\_database\_catalog](#input\_list\_glue\_database\_catalog) | The database catalog name | `list(string)` | `[]` | no |
| <a name="input_specific_folder"></a> [specific\_folder](#input\_specific\_folder) | The crawler run in specific folder in the bucket | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_db_name"></a> [catalog\_db\_name](#output\_catalog\_db\_name) | n/a |
| <a name="output_crawler_arn"></a> [crawler\_arn](#output\_crawler\_arn) | n/a |
| <a name="output_crawler_name_s3"></a> [crawler\_name\_s3](#output\_crawler\_name\_s3) | n/a |
<!-- END_TF_DOCS -->