## Examples:

```bash
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
            event_pattern = file("./event_pattern.json")
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

  policy = templatefile("./glue_eventbridge_policy.json", {TargetARN=aws_glue_workflow.workflow.arn})
}
```