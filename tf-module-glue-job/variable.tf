##############################
# Variable AWS Glue ETL job #
##############################

variable "job_name" {
  type        = string
  description = "Glue job name. If not provided, the name will be generated from the context."
  default     = null
}

variable "job_description" {
  type        = string
  description = "Glue job description."
  default     = "Glue ETL job"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role associated with this job."
}

variable "connections" {
  type        = list(string)
  description = "The list of connections used for this job."
  default     = null
}

variable "glue_version" {
  type        = string
  description = "The version of Glue to use."
  default     = "4.0"
}
variable additional_arguments{
    type = map(string)
    description = "Add more arguments for the ETL job"
    default = {}

}
variable "target_bucket_arn" {
    type = string
    description = "The s3 bucket to store the result from the etl job"
    default = null
  
}
variable "default_arguments" {
  type        = map(string)
  description = "The map of default arguments for the job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes."
  default     =  {
      # ... potentially other arguments ...a
      "--enable-continuous-cloudwatch-log" = "true"
      "--enable-continuous-log-filter"     = "true"
      "--enable-metrics"                   = "true"
      "--job-language"                     = "python"
      "--enable-observability-metrics"     = "true"
      "--enable-spark-ui"                  = "true"
    }
}

variable "non_overridable_arguments" {
  type        = map(string)
  description = "Non-overridable arguments for this job, specified as name-value pairs."
  default     = null
}

variable "security_configuration" {
  type        = string
  description = "The name of the Security Configuration to be associated with the job."
  default     = null
}

variable "timeout" {
  type        = number
  description = "The job timeout in minutes. The default is 2880 minutes (48 hours) for `glueetl` and `pythonshell` jobs, and `null` (unlimited) for `gluestreaming` jobs."
  default     = 2880
}

variable "max_capacity" {
  type        = number
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when the job runs. Required when `pythonshell` is set, accept either 0.0625 or 1.0. Use `number_of_workers` and `worker_type` arguments instead with `glue_version` 2.0 and above."
  default     = null
}

variable "max_retries" {
  type        = number
  description = " The maximum number of times to retry the job if it fails."
  default     = null
}

variable "worker_type" {
  type        = string
  description = "The type of predefined worker that is allocated when a job runs. Accepts a value of `Standard`, `G.1X`, or `G.2X`."
  default     = null
}

variable "number_of_workers" {
  type        = number
  description = "The number of workers of a defined `worker_type` that are allocated when a job runs."
  default     = null
}


variable "command" {
  #  type = object({
  #    # The name of the job command. Defaults to `glueetl`.
  #    # Use `pythonshell` for Python Shell Job Type, or `gluestreaming` for Streaming Job Type.
  #    name = string
  #    # Specifies the S3 path to a script that executes the job
  #    script_location = string
  #    # The Python version being used to execute a Python shell job. Allowed values are 2 or 3
  #    python_version = number
  #  })

  # Using `type = map(any)` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = map(any)
  description = "The command of the job."

}
variable "s3_bucket_script" {
  type = string
  description = "The bucket that store the  the script"
}
variable "local_script_path" {
    type = string 
    description = "The path to script in the local"
  
}