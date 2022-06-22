resource "aws_sns_topic" "test-notifications" {
 name = var.sns_name

 tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_sns_topic_subscription" "test-notifications" {
 for_each = var.sqs_arn
 topic_arn = aws_sns_topic.test-notifications.arn
 protocol = "sqs"
 endpoint = each.value
}

