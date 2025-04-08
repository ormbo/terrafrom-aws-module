locals {
  aws_service_policies = {
    lambda = {
      lambda = {
        actions = ["lambda:InvokeFunction"]
      }
    }

    sns = {
      sns = {
        actions = ["sns:Publish"]
      }
    }

    sqs = {
      sqs = {
        actions = ["sqs:SendMessage"]
      }
    }

    xray = {
      xray = {
        actions = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        default_resources = ["*"]
      }
    }

    s3 = {
      s3 = {
        actions = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:CreateBucket",
          "s3:PutObject"
        ]
        default_resources = ["arn:aws:s3:::*"]
      }
    }
    secretsmanager = {
      secretsmanager = {
        actions = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets"
        ]
        default_resources = ["arn:aws:secretsmanager:*"]
      }
    }
    glue = {
      glue = {
        actions = [
          "glue:CreateDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:DeleteTable",
          "glue:BatchDeleteTable",
          "glue:BatchCreatePartition",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition",
          "glue:DeletePartition",
          "glue:BatchDeletePartition"
        ]
      }
    },

    redshift = {
      redshift = {
        actions = [
          "redshift:*",
          "redshift-data:ExecuteStatement",
          "redshift-data:CancelStatement",
          "redshift-data:ListStatements",
          "redshift-data:GetStatementResult",
          "redshift-data:DescribeStatement",
          "redshift-data:ListDatabases",
          "redshift-data:ListSchemas",
          "redshift-data:ListTables",
          "redshift-data:DescribeTable",
          "redshift:GetClusterCredentials",
          "redshift:DescribeClusters",
          "redshift:ExecuteStatement",
          "redshift:GetStatementResult",
          "redshift:BatchExecuteStatement"
        ]
        default_resources = ["arn:aws:redshift:*"]
      }
    },

    dynamodb = {
      dynamodb = {
        actions = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
      }
    },

    glue_Sync = {
      glue = {
        actions = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:BatchStopJobRun"
        ]
        default_resources = ["*"]
      }
    },

    stepfunction_Sync = {
      stepfunction = {
        actions = ["states:StartSyncExecution"]
      }

      stepfunction_Wildcard = {
        actions = ["states:DescribeExecution", "states:StopExecution"]
      }

      events = {
        actions = ["events:PutTargets", "events:PutRule", "events:DescribeRule"]
        default_resources = ["arn:aws:events:${data.aws_region.aws_region.name}:${data.aws_caller_identity.current.account_id}:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"]
      }
    },

    stepfunction = {
      stepfunction = {
        actions = ["states:StartExecution"]
      }
    },

    eventbridge = {
      eventbridge = {
        actions = ["events:PutEvents"]
        default_resources = ["*"]
      }
    },

    no_tasks = {
      deny_all = {
        effect            = "Deny"
        actions           = ["*"]
        default_resources = ["*"]
      }
    }
  }

  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.aws_region.name
}

data "aws_caller_identity" "current" {}
data "aws_region" "aws_region" {}
