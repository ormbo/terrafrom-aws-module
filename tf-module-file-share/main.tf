################################################################################
# SMB File Share
################################################################################

resource "aws_storagegateway_smb_file_share" "smbshare" {
  file_share_name       = var.share_name
  authentication        = var.authentication
  gateway_arn           = var.gateway_arn
  location_arn          = var.bucket_arn
  default_storage_class = var.storage_class
  role_arn              = aws_iam_role.storagegateway.arn
  admin_user_list       = var.authentication == "ActiveDirectory" ? var.admin_user_list : []
  smb_acl_enabled       = false
  audit_destination_arn = aws_cloudwatch_log_group.log_group_file_share.arn
  kms_encrypted         = var.kms_encrypted
  kms_key_arn           = var.kms_encrypted ? var.kms_key_arn : null

  cache_attributes {
    cache_stale_timeout_in_seconds = var.cache_timeout
  }

  tags = var.tags

}


resource "aws_iam_role" "storagegateway" {
  name               = "S3-permission-storagegateway-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["storagegateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "S3_permission" {
  statement {
    effect  = "Allow"
    actions = [
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketLocation",
                "s3:GetBucketVersioning",
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:ListBucketMultipartUploads"
            ]
    resources = ["${var.bucket_arn}"]
    }
    statement {
          effect  = "Allow"
      actions = [
                "s3:AbortMultipartUpload",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion",
                "s3:ListMultipartUploadParts",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ]
    resources = ["${var.bucket_arn}/*"]
    }
}
resource "aws_iam_policy" "policy" {
  name        = "S3-permission-storagegateway-policy"
  description = "Policy for storage gateway to grant permission to s3"
  policy      = data.aws_iam_policy_document.S3_permission.json
}
resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = aws_iam_role.storagegateway.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_cloudwatch_log_group" "log_group_file_share" {
  name = "Cloud-Watch-Storage-Gateway-${var.share_name}"
}
