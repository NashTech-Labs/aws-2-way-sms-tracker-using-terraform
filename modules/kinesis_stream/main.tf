resource "aws_kinesis_stream" "test-notifications" {
 name = var.kinesis_stream_name
 shard_count = 3
 retention_period = 24
 encryption_type = "KMS"
 kms_key_id = "alias/${var.kms_key_alias}"

 tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_kinesis_stream_consumer" "test-notification" {
 name       = "${var.environment}.aws-sms-tracker"
 stream_arn = aws_kinesis_stream.test-notifications.arn
}

