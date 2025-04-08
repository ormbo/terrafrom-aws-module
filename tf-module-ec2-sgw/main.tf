##########################
## Create EC2 Instance ##
##########################
data "aws_region" "aws_region" {}
data "aws_caller_identity" "current" {}



locals {
  vpc_security_group_ids = var.create_security_group ? [aws_security_group.ec2_sg["ec2_sg"].id] : [var.security_group_id]

}


resource "aws_instance" "ec2_sgw" {
  ami                    = data.aws_ami.sgw_ami.id
  vpc_security_group_ids = local.vpc_security_group_ids
  subnet_id              = var.subnet_id
  instance_type          = var.instance_type
  key_name               = try(var.ssh_key_name, "")
  ebs_optimized          = true
  availability_zone      = var.availability_zone

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = try(tonumber(var.root_block_device["disk_size"]), 80)
    volume_type = try(var.root_block_device["volume_type"], "gp3")
    kms_key_id  = try(var.root_block_device["kms_key_id"], null)
  }
  tags = merge(var.tags, {
    Name = var.name
  },)
  lifecycle {
    # the Security group ID must be non-empty or create_security_group must be true
    precondition {
      condition     = var.create_security_group || try((length(var.security_group_id) > 3 && substr(var.security_group_id, 0, 3) == "sg-"), false)
      error_message = "Please specify create_security_group = true or provide a valid Security Group ID for var.security_group_id"
    }
  }
}

data "aws_ami" "sgw_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["aws-storage-gateway-FILE_S3*"]
  }
  tags = var.tags
}

resource "aws_eip" "ip" {
    count = var.create_vpc_endpoint ? 0 : 1
}

resource "aws_eip_association" "eip_assoc" {
  count = var.create_vpc_endpoint ? 0 : 1
  instance_id   = aws_instance.ec2_sgw.id
  allocation_id = try(aws_eip.ip[0].id, null)
}


resource "aws_volume_attachment" "ebs_volume" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.cache_disk.id
  instance_id = aws_instance.ec2_sgw.id

}

resource "aws_ebs_volume" "cache_disk" {
  availability_zone = aws_instance.ec2_sgw.availability_zone
  encrypted         = true
  size              = try(tonumber(var.cache_block_device["disk_size"]), 150)
  type              = try(var.cache_block_device["volume_type"], "gp3")
  kms_key_id        = try(var.cache_block_device["kms_key_id"], null)
  tags = var.tags
}


resource "aws_vpc_endpoint" "storagegateway" {
    count = var.create_vpc_endpoint ? 1 : 0 
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.${data.aws_region.aws_region.name}.storagegateway"
    vpc_endpoint_type = "Interface"
    subnet_ids        = [var.subnet_id]

    security_group_ids = [
        try(aws_security_group.security_group_endpoint[0].id, var.vpc_endpoint_sg_id),
    ]

    private_dns_enabled = true
    tags = merge(var.tags, {
        Name = "endpoint-storage-gateway"
    })
}

resource "aws_security_group" "security_group_endpoint" {
    count = var.create_vpc_endpoint_sg && var.create_vpc_endpoint ? 1 : 0
    name        = "Endpoint-HTTPS-storage-gateway"
    description = "Allow inbound traffic for the VPC Endpoint"
    vpc_id      = var.vpc_id

    ingress {
        description = "HTTPS for the storage gateway vpc"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [var.ingress_cidr_block_activation]
  }
      ingress {
        description = "TCP port for storage gateway vpc"
        from_port   = 1026
        to_port     = 1028
        protocol    = "tcp"
        cidr_blocks = [var.ingress_cidr_block_activation]
  }
      ingress {
        description = "TCP port for storage gateway vpc"
        from_port   = 1031
        to_port     = 1031
        protocol    = "tcp"
        cidr_blocks = [var.ingress_cidr_block_activation]
  }
      ingress {
        description = "TCP port for storage gateway vpc"
        from_port   = 2222
        to_port     = 2222
        protocol    = "tcp"
        cidr_blocks = [var.ingress_cidr_block_activation]
  }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.ingress_cidr_block_activation]
    }
  tags =merge(var.tags, {
    Name = "Endpoint-HTTPS-storage-gateway"
  }) 
}

resource "aws_iam_role" "role_ec2_instance_profile" {
  name               = "runner_ec2_role_instance_profile"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_instance_profile" "runner_ec2_profile" {
  name = "runner_ec2_profile"
  role = aws_iam_role.role_ec2_instance_profile.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

}

data "aws_iam_policy_document" "PutParameter_permission" {
  statement {
    effect  = "Allow"
    actions = [	
				"ssm:GetParameter",
				"ssm:PutParameter"]
    resources = [aws_ssm_parameter.create.arn]
    }
}
resource "aws_iam_policy" "policy" {
  name        = "PutParameter-Activatio-Key"
  description = "Policy for put in Parameter store"
  policy      = data.aws_iam_policy_document.PutParameter_permission.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = aws_iam_role.role_ec2_instance_profile.name
  policy_arn = aws_iam_policy.policy.arn

}


resource "aws_instance" "runner_ec2" {

  ami           = "ami-08b5b3a93ed654d19"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = local.vpc_security_group_ids
  iam_instance_profile = aws_iam_instance_profile.runner_ec2_profile.name

  user_data = <<-EOF
  #!/bin/bash

  TARGET_URL="http://${aws_instance.ec2_sgw.private_ip}/?activationRegion=${data.aws_region.aws_region.name}&vpcEndpoint=storagegateway.${data.aws_region.aws_region.name}.amazonaws.com&no_redirect"

  echo "Waiting for a valid response from $TARGET_URL..."

  RESPONSE=""

  while true; do
    RESPONSE=$(curl -s "$TARGET_URL")
    
    if [[ -z "$RESPONSE" || "$RESPONSE" == "null" ]]; then
      echo "No response yet. Retrying in 5 seconds..."
      sleep 5
    else
      echo "Received response: $RESPONSE"
      break
    fi
  done

  echo "Saving to AWS SSM Parameter Store..."
  aws ssm put-parameter --name "/sgw/activation_key" --value "$RESPONSE" --type "SecureString" --overwrite --region "${data.aws_region.aws_region.name}"
  EOF
  tags = merge(var.tags, {
    Name = "Runner-EC2"
  })
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ami, instance_type]  # Ignore changes to avoid recreation if you modify the instance type or AMI.
  }
  depends_on = [time_sleep.wait_for_storage_gateway_up ]

}

resource "aws_ssm_parameter" "create" {
  name = "/sgw/activation_key"
  description = "The Activation-Key of the Storage Gateway, after the Storage Gateway is active this parameter can be deleted"
  type = "SecureString"
  value = "Activation-Key"

  lifecycle {
    ignore_changes = [ value, type, name ]
  }
  tags = var.tags
}

resource "time_sleep" "wait_for_storage_gateway_up" {
  depends_on = [aws_instance.ec2_sgw]

  create_duration = "150s"
}

