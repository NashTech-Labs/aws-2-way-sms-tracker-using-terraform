resource "aws_pinpoint_app" "test-notifications" {
 name = var.pinpoint_name

 tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_pinpoint_sms_channel" "test-notifications" {
 application_id = aws_pinpoint_app.test-notifications.application_id
}

resource "aws_pinpoint_event_stream" "test-notifications" {
 application_id         = aws_pinpoint_app.test-notifications.application_id
 destination_stream_arn = var.kinesis_stream_arn
 role_arn               = data.aws_iam_role.Pinpoint_to_Kinesis_Generate_Data_Key.arn
}

resource "aws_iam_role" "test-notifications-pinpoint-role" {
 name = "test-notifications-pinpoint-role"
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "pinpoint.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy" "test-notifications-pinpoint-policy" {
 name = "test-notifications-pinpoint-policy"
 role = aws_iam_role.test-notifications-pinpoint-role.id

 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "kms:GenerateDataKey"
       ],
   "Resource": "*"
   },
   {
     "Effect": "Allow",
     "Action": [
       "kinesis:PutRecord",
       "kinesis:PutRecords",
       "kinesis:DescribeStream"
       ],
     "Resource": "*"
   }
 ]
}
EOF
}


