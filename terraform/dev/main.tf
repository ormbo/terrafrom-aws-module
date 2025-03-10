module "aws_cloudtrail_s3" {
    source = "../../tf-cloudtrail-module"

    aws_cloudtrail_name = "cloud-trail-s3-test"
    bucket_list_arn = [ "arn:aws:s3:::dwh-bi-development-s3" ]
    use_existing_s3_for_logs = true
    s3_bucket_logs_name = "dwh-bi-state-s3"
    enable_cloudWatch_logs = false
}