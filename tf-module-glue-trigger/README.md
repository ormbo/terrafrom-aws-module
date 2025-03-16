## Examples:

```bash

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
```