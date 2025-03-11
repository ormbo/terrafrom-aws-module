resource "aws_glue_trigger" "example-start" {
    name          = var.trigger_name
    type          = var.type
    workflow_name = var.with_workflow ? var.workflow_name : null
  dynamic "actions" {
    for_each = var.actions

    content {
      job_name               = try(actions.value.job_name, null)
      crawler_name           = try(actions.value.crawler_name, null)
      arguments              = try(actions.value.arguments, null)
      security_configuration = try(actions.value.security_configuration, null)
      timeout                = try(actions.value.timeout, null)

      dynamic "notification_property" {
        for_each = try(actions.value.notification_property, null) != null ? [true] : []
        content {
          notify_delay_after = try(actions.value.notification_property.notify_delay_after, null)
        }
      }
    }
  }

  dynamic "event_batching_condition" {
    for_each = var.event_batching_condition != null ? [true] : []

    content {
      batch_size   = var.event_batching_condition.batch_size
      batch_window = try(var.event_batching_condition.batch_window, null)
    }
  }
}