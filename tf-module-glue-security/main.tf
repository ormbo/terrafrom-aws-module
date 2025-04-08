locals {
  existing_policies = { for k, v in local.aws_service_policies : k => v if contains(keys(var.service_integrations), k) }
}

################################
# Create IAM Role for Glue job #
###############################
resource "aws_iam_role" "glue_role" {
  name        = var.glue_iam_role_name
  description = "Role for AWS Glue" 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(var.tags, {
    Glue = "IAM-role"
  })
}
##############################
# Attach AWS Glue Policy #
##############################
resource "aws_iam_role_policy_attachment" "glue_policy_attachment" {
  count = length(var.base_policies_iam_role_glue)
  role       = aws_iam_role.glue_role.name
  policy_arn = var.base_policies_iam_role_glue[count.index]
}

##############################
# Attach Additional Policies #
##############################
resource "aws_iam_role_policy_attachment" "additional_policies" {
  count      = length(var.additional_iam_policy)
  role       = aws_iam_role.glue_role.name
  policy_arn = var.additional_iam_policy[count.index]

}


resource "aws_security_group" "glue-security-group" {
  name        = "glue-security-group"
  description = "Allow Glue all TCP port"
  vpc_id      = var.vpc_id
    ingress {
      description = "All TCP Port"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  tags = merge(var.tags, {
    Name = "glue-security-group"
  })
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "service" {
  for_each = { for k, v in var.service_integrations : k => v if var.attach_policies_for_integrations }

  dynamic "statement" {
    for_each = each.value

    content {
      effect    = lookup(local.aws_service_policies[each.key][statement.key], "effect", "Allow")
      sid       = replace("${each.key}${title(statement.key)}", "/[^0-9A-Za-z]*/", "")
      actions   = local.aws_service_policies[each.key][statement.key]["actions"]
      resources = statement.value == true ? local.aws_service_policies[each.key][statement.key]["default_resources"] : tolist(statement.value)

      dynamic "condition" {
        for_each = lookup(local.aws_service_policies[each.key][statement.key], "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "service" {
  for_each = { for k, v in var.service_integrations : k => v if var.attach_policies_for_integrations }

  name   = "${var.glue_iam_role_name}-${each.key}"
  path   = "/"
  policy = data.aws_iam_policy_document.service[each.key].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "service" {
  for_each = { for k, v in var.service_integrations : k => v if var.attach_policies_for_integrations }

  name       = "${var.glue_iam_role_name}-${each.key}"
  roles = [aws_iam_role.glue_role.name]
  policy_arn = aws_iam_policy.service[each.key].arn
}
