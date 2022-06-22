output "sqs_arn" {
 value = aws_sqs_queue.test-notifications.arn
}

output "sqs_name" {
 value = aws_sqs_queue.test-notifications.name
}


