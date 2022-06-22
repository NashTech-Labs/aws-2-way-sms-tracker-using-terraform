resource "aws_kms_key" "test-notifications" {
 policy = aws_iam_policy_document.test-notifications.json
 is_enabled = true
 enable_key_rotation = true

tags = {
   environment = var.environment
   team = var.team
 }
}

resource "aws_kms_alias" "test-notifications" {
 name = "alias/${var.kms_key_alias}"
 target_key_id = aws_kms_key.test-notifications.key_id
}

resourse "aws_iam_policy_document" "test-notifications" {
 statement {
   sid = "Enable IAM User Permissions"
   actions = ["kms:*"]
   principals {
     type = "AWS"
     identifiers = [
       "arn:aws:iam::${var.account_id}:root"]
   }
   resources = ["*"]
 }

 statement {
   sid = "Allow use of the key"
   actions = [
     "kms:Encrypt",
     "kms:Decrypt",
     "kms:ReEncrypt*",
     "kms:GenerateDataKey*",
     "kms:DescribeKey"
   ]
   principals {
     type = "AWS"
     identifiers = [
       "arn:aws:iam::${var.account_id}:user/svc-aws-sms-receiver",
       "arn:aws:iam::${var.account_id}:user/svc-aws-sms-tracker"
     ]
   }
   resources = ["*"]
 }
 statement {
   sid = "Allow attachment of persistent resources"
   actions = [
     "kms:CreateGrant",
     "kms:ListGrants",
     "kms:RevokeGrant"
   ]
   principals {
     type = "AWS"
     identifiers = [
       "arn:aws:iam::${var.account_id}:user/svc-aws-sms-receiver",
       "arn:aws:iam::${var.account_id}:user/svc-aws-sms-tracker"
     ]
   }
   resources = ["*"]
 }
 statement {
   sid = "SNS decrypt permission"
   actions = [
     "kms:GenerateDataKey*",
     "kms:Decrypt",
   ]
   principals {
     type = "Service"
     identifiers = ["sns.amazonaws.com"]
   }
   resources = ["*"]
 }
}

