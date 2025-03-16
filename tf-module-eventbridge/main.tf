







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