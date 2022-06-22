output "Pinpoint_app_id" {
 value = module.two-way-notifications-pinpoint.pinpoint_application_id
}

output "Pinpoint_app_name" {
 value = module.two-way-notifications-pinpoint.pinpoint_application_name
}

output "Pinpoint_app_arn" {
 value = module.two-way-notifications-pinpoint.pinpoint_application_arn
}

output "sqs_queue_arns" {
 value = { for queue, arn in module.two-way-notifications-encrypted-sqs-set: queue => arn.sqs_arn }
}

output "sns_topic_arn" {
 value = module.two-way-notifications-sns.sns_arn
}

output "sns_topic_name" {
 value = module.two-way-notifications-sns.sns_name
}

output "kms_id" {
 value = module.two-way-notifications-kms-encryption-key.kms_key_id
}

output "kms_alias" {
 value = module.two-way-notifications-kms-encryption-key.kms_alias
}

output "kinesis_stream_id" {
 value = module.two-way-notifications-kinesis-stream.kinesis_stream_id
}

output "kinesis_stream_arn" {
 value = module.two-way-notifications-kinesis-stream.kinesis_stream_arn
}

output "kinesis_stream_name" {
 value = module.two-way-notifications-kinesis-stream.kinesis_stream_name
}


