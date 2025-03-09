
module "s3-bucket-CloudTrail-Logs" {
    count = var.use_existing_s3 ? 1 : 0 
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
    name                          = var.aws_cloudtrail_name
    s3_bucket_name                = var.use_existing_s3 ? module.s3-bucket-CloudTrail-Logs[0].s3_bucket_id : var.s3_bucket_logs_name
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

        #The trailing slash is intentional; do not exclude it.
        starts_with =  var.bucket_list_arn
        }

        field_selector {
        field  = "readOnly"
        equals = ["false"]
        }

        field_selector {
        field  = "resources.type"
        equals = ["AWS::S3::Object"]
        }
    }

    cloud_watch_logs_group_arn =  var.enable_cloudWatch_logs ? "${aws_cloudwatch_log_group.s3-cloud-watch-logs}:*" : null
}

resource "aws_cloudwatch_log_group" "s3-cloud-watch-logs" {
    count = var.enable_cloudWatch_logs ? 1 : 0
    name = "s3-cloud-trail"
}
