module "aws_cloudtrail_s3" {
    source = "../../tf-cloudtrail-module"

    aws_cloudtrail_name       = "cloud-trail-s3-test"
    bucket_list_arn_to_trail  = [ "arn:aws:s3:::dwh-bi-development-s3","arn:aws:s3:::dwh-bi-state-s3" ]
    use_existing_s3_for_logs  = true
    s3_bucket_logs_name       = "dwh-bi-state-s3"
    enable_cloudWatch_logs    = false
}

module "eventbridge" {
    source  = "terraform-aws-modules/eventbridge/aws"
    version = "3.14.3"

    create_bus = false  
    create_role = true
    role_name = "EventBridgeTest"
    attach_policy = true

    policy = aws_iam_policy.glue_invoke.arn
    rules = {
            glue_workflow_trigger = {
            description = "Capture the s3 PutObject",
            event_pattern = jsonencode({
                "source": ["aws.s3"],
                "detail-type": ["AWS API Call via CloudTrail"],
                "detail": {
                    "eventSource": ["s3.amazonaws.com"],
                    "eventName": ["PutObject"]
                }
                })
            }
    }
    targets = {
            glue_workflow_trigger = [
                {   
                    name = "glue_workflow_trigger"
                    arn  = aws_glue_workflow.workflow.arn
                    attach_role_arn    = true
                    target_id = "workflow-test"
                }]
        }

    }


resource "aws_iam_policy" "glue_invoke" {
  name        = "glue-invoke-policy"
  description = "Allows EventBridge to trigger Glue Workflow"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "glue:notifyEvent"
        Effect   = "Allow"
        Resource = aws_glue_workflow.workflow.arn
      }
    ]
  })
}

resource "aws_glue_workflow" "workflow" {
  name = "test-workflow"
  
}

module "aws_glue_trigger" {
    source = "../../tf-module-glue-trigger"

    trigger_name = "check"
    with_workflow = true
    workflow_name = aws_glue_workflow.workflow.name
    type = "EVENT"
    actions = [{
        job_name = "test"
    }]
    event_batching_condition={
      batch_size = 1
      batch_window = 900
    }
    

}