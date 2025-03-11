################################
# Create IAM Role for Glue job #
###############################
resource "aws_iam_role" "glue_role" {
  name = var.glue_iam_role_name
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
  tags = {
    Glue = "IAM-role"
  }
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
  tags = {
    Name = "glue-security-group"
  }
  lifecycle {
    create_before_destroy = true
  }
}

