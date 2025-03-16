variable "with_workflow" {
  type = bool
  description = "attach the trigger to workflow"
  
}
variable "workflow_name" {
    type = string
    description = "The workflow name"
    default = null
}
variable "trigger_name" {
    type = string
    description = "The trigger name"
}
variable "type" {
    type = string
    description = "The type of trigger. Valid values are CONDITIONAL, EVENT, ON_DEMAND, and SCHEDULED "
}
variable "actions" {
  #  type = list(object({
  #    job_name               = string
  #    crawler_name           = string
  #    arguments              = map(string)
  #    security_configuration = string
  #    notification_property = object({
  #      notify_delay_after = number
  #    })
  #    timeout = number
  #  }))

  # Using `type = list(any)` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = list(any)
  description = "List of actions initiated by the trigger when it fires."
}
variable "event_batching_condition" {
  #  type = object({
  #    batch_size   = number
  #    batch_window = number
  #  })

  # Using `type = map(number)` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = map(number)
  description = "Batch condition that must be met (specified number of events received or batch time window expired) before EventBridge event trigger fires."
  default     = null
}
