 # Map for SQS queue & respective SQS dlq for ucloud
locals {
 sqs_queues = {
                                                 # SQS Queue            =       Respective SQS DLQ      
     "aws-sms-receiver-sqs-queue-ucloud-${var.environment}-environment" = "aws-sms-receiver-sqs-dlq-ucloud-${var.environment}-environment",
 }
}

#disabled Module because we creating pinpoint project manually

 module "two-way-notifications-pinpoint" {
 source = "./modules/pinpoint"
 pinpoint_name = "two-way-sms-pinpoint-app-${var.environment}-environment"
 kinesis_stream_arn = module.two-way-notifications-kinesis-stream.kinesis_stream_arn
 datacenter = var.datacenter
 environment = var.environment
 team = var.team
}


module "two-way-notifications-sns" {
 source = "./modules/sns"
 sqs_arn =  { for queue, arn in module.two-way-notifications-encrypted-sqs-set: queue => arn.sqs_arn }
 sns_name = "two-way-sms-sns-topic-${var.environment}-environment"
 datacenter = var.datacenter
 environment = var.environment
 team = var.team
}

module two-way-notifications-encrypted-sqs-set {
 source = "./modules/sqs"
 for_each = local.sqs_queues
 sqs_name = each.key
 sqs_dlq_name = each.value
 sns_arn = module.two-way-notifications-sns.sns_arn
 environment = var.environment
 team = var.team
 kms_key_alias = var.kms_key_alias
}

module "two-way-notifications-kms-encryption-key" {
 source = "./modules/kms"
 datacenter = var.datacenter
 environment = var.environment
 team = var.team
 account_id = var.account_id
 kms_key_alias = var.kms_key_alias
}

module "two-way-notifications-kinesis-stream" {
 kinesis_stream_name = "aws-sms-tracker-kinesis-stream-${var.environment}-environment"
 source = "./modules/kinesis_stream"
 datacenter = var.datacenter
 environment = var.environment
 team = var.team
 kms_key_alias = var.kms_key_alias
}


