resource "aws_sqs_queue" "test-notifications" {
 name = var.sqs_name
 delay_seconds = 0
 max_message_size = 262144
 message_retention_seconds = 345600
 receive_wait_time_seconds = 0
 kms_master_key_id = "alias/${var.kms_key_alias}"
 kms_data_key_reuse_period_seconds = 300
 redrive_policy = jsonencode({
   deadLetterTargetArn = aws_sqs_queue.test-notifications-dlq.arn
   maxReceiveCount = 4
 })

 tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_sqs_queue" "test-notifications-dlq" {
 name = var.sqs_dlq_name
 delay_seconds = 0
 max_message_size = 262144
 message_retention_seconds = 345600
 receive_wait_time_seconds = 20
 kms_master_key_id = "alias/${var.kms_key_alias}"
 kms_data_key_reuse_period_seconds = 300

 tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_sqs_queue_policy" "test-notifications" {
 queue_url = aws_sqs_queue.test-notifications.id
 policy = <<POLICY
{
 "Version": "2012-10-17",
 "Id": "sqspolicy",
 "Statement": [
   {
     "Sid": "First",
     "Effect": "Allow",
     "Principal": "*",
     "Action": "sqs:SendMessage",
     "Resource": "${aws_sqs_queue.test-notifications.arn}",
     "Condition": {
       "ArnEquals": {
         "aws:SourceArn": "${var.sns_arn}"
       }
     }
   }
 ]
}
POLICY
}

