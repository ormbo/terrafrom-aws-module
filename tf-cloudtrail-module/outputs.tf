output "bucket_log_cloudtrail"{
    value = aws_cloudtrail.cloudtrail-s3.s3_bucket_name
}