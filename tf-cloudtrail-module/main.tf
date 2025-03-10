data "aws_s3_bucket" "s3_log_data" {
  bucket = var.s3_bucket_logs_name
}


module "s3-bucket-CloudTrail-Logs" {
    count = var.use_existing_s3_for_logs ? 0 : 1
    source            = "terraform-aws-modules/s3-bucket/aws"
    version           = "4.5.0"

    bucket = "s3-bucket-CloudTrail-Logs"
    acl    = "private"
    control_object_ownership = true
    object_ownership         = "ObjectWriter"
    versioning = {
        enabled = true
    }
}

resource "aws_cloudtrail" "cloudtrail-s3" {
    depends_on                 = [aws_s3_bucket_policy.cloudtrail_bucket_policy]
    name                          = var.aws_cloudtrail_name
    s3_bucket_name                = var.use_existing_s3_for_logs ? var.s3_bucket_logs_name : try(module.s3-bucket-CloudTrail-Logs[0].s3_bucket_id, "")
    s3_key_prefix                 = "Logs"
    include_global_service_events = false


    advanced_event_selector {
        name = "Log PutObject and DeleteObject events for two S3 buckets"

        field_selector {
        field  = "eventCategory"
        equals = ["Data"]
        }

        field_selector {
        field = "eventName"
        equals = [
            "PutObject",
            "DeleteObject"
        ]
        }
        field_selector {
        field = "resources.ARN"

        # The trailing slash is intentional; do not exclude it.
        starts_with = var.bucket_list_arn_to_trail
        }
        field_selector {
        field  = "resources.type"
        equals = ["AWS::S3::Object"]
        }
    }

    cloud_watch_logs_group_arn = var.enable_cloudWatch_logs ? "${aws_cloudwatch_log_group.s3-cloud-watch-log-group[0].arn}:*" : null
    cloud_watch_logs_role_arn  = var.enable_cloudWatch_logs ? aws_iam_role.cloudtrail_logs_role[0].arn : null

}

data "aws_iam_policy_document" "iam_policy_s3_logs" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [
      var.use_existing_s3_for_logs ? data.aws_s3_bucket.s3_log_data.arn : try(module.s3-bucket-CloudTrail-Logs[0].s3_bucket_arn, "")
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [
        "arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.aws_cloudtrail_name}"
      ]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = [
      "${var.use_existing_s3_for_logs? data.aws_s3_bucket.s3_log_data.arn : try(module.s3-bucket-CloudTrail-Logs[0].s3_bucket_arn, "")}/Logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [
        "arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.aws_cloudtrail_name}"
      ]
    }
  }
}


resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = var.use_existing_s3_for_logs ? var.s3_bucket_logs_name : try(module.s3-bucket-CloudTrail-Logs[0].s3_bucket_id, "")
  policy = data.aws_iam_policy_document.iam_policy_s3_logs.json
}

resource "aws_cloudwatch_log_group" "s3-cloud-watch-log-group" {
    count = var.enable_cloudWatch_logs ? 1 : 0
    name = "s3-cloud-trail"
}
resource "aws_iam_role" "cloudtrail_logs_role" {
  count = var.enable_cloudWatch_logs ? 1 : 0
  name  = "cloudtrail_logs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "cloudtrail_logs_policy" {
  count = var.enable_cloudWatch_logs ? 1 : 0
  name        = "cloudtrail_logs_policy"
  description = "Allow CloudTrail to publish logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
        Effect   = "Allow"
        Action   = "logs:CreateLogStream"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.s3-cloud-watch-log-group[0].name}:log-stream:*"

      },
      {
        Effect   = "Allow"
        Action   = "logs:PutLogEvents"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.s3-cloud-watch-log-group[0].name}:log-stream:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail_logs_policy_attachment" {
  count = var.enable_cloudWatch_logs ? 1 : 0
  role  = aws_iam_role.cloudtrail_logs_role[0].name
  policy_arn = aws_iam_policy.cloudtrail_logs_policy[0].arn
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
