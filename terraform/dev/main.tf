
# data "aws_availability_zones" "available" {}



# module "aws_glue_security" {
#     source =  "../../../terrafrom-aws-module/tf-module-glue-security"

#     vpc_id                  =   "vpc-06e7dd7eccec7a493"
#     glue_iam_role_name      =   "glue-iam-role-terraform-module"
#     additional_iam_policy   =   ["arn:aws:iam::aws:policy/SecretsManagerReadWrite"]
# }

#  module "ec2_sgw" {
#     source     = "../../../terrafrom-aws-module/tf-module-ec2-sgw"

#     name                               = "ec2-storage-gateway" 
#     availability_zone                  = data.aws_availability_zones.available.names[0] 
#     subnet_id                          = "subnet-0f223283350d92e03"
#     ingress_cidr_block_activation      = "10.0.1.0/28"
#     ssh_key_name                       = "storage-gateway"
#     create_vpc_endpoint                = true
#     create_security_group              = true
#     create_vpc_endpoint_sg             = true 
#     vpc_id                             = "vpc-06e7dd7eccec7a493"
#     timezone                           = "GMT+2:00"

#  }

# module "create_sgw" {
#     source = "../../../terrafrom-aws-module/tf-module-sgw"

#     storagegateway_name = "test"
#     gateway_type        = "FILE_S3"
#     timezone            = "GMT+2:00"
#     cloudwatch_logs     = true
#     device_name         = module.ec2_sgw.device_name
#     depends_on          = [ module.ec2_sgw]
    
# }

# module "file_share_smb" {
#   source = "../../../terrafrom-aws-module/tf-module-file-share"

#   share_name    = "Test-share"
#   gateway_arn   = module.create_sgw.gateway_arn
#   create_bucket = true
#   bucket_name   = "dwh-bucket-for-file-storage-gateway"
#   authentication = "GuestAccess"

#   depends_on = [ module.create_sgw  ]
# }


 module "aws_cloudtrail_s3" {
     source = "../../tf-cloudtrail-module"

     aws_cloudtrail_name       = "cloud-trail-s3-test"
     bucket_list_arn_to_trail  = [ "arn:aws:s3:::dwh-bi-development-s3","arn:aws:s3:::dwh-bi-state-s3" ]
     use_existing_s3_for_logs  = true
    s3_bucket_logs_name       = "dwh-bi-state-s3"
    enable_cloudWatch_logs    = false
}

########################################################################################################################################
########################################################################################################################################
#                   --------------------------- Create cloud trail for s3 ---------------------------- 
########################################################################################################################################
########################################################################################################################################


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