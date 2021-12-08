#-----------------------------------------------------------------------------------------------------------------------
# Optionally configure Event Bridge (formerly CloudWatchEvents) Rules and SNS subscriptions
# We would like the SNS Topic to be encrypted, and EventBridge requires sufficient permissions for the KMS key
# https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cwe-integration-types.html
# https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html
#-----------------------------------------------------------------------------------------------------------------------

module "sns_kms_key_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  count   = local.create_sns_topic ? 1 : 0

  attributes = ["securityhub"]
  context    = module.this.context
}

module "sns_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.10.0"
  count   = local.create_sns_topic ? 1 : 0

  name                = local.create_sns_topic ? module.sns_kms_key_label[0].id : ""
  description         = "KMS key for the security-hub Imported Findings SNS topic"
  enable_key_rotation = true
  alias               = "alias/security-hub-sns"
  policy              = local.create_sns_topic ? data.aws_iam_policy_document.sns_kms_key_policy[0].json : ""

  context = module.this.context
}

data "aws_iam_policy_document" "sns_kms_key_policy" {
  count = local.create_sns_topic ? 1 : 0

  policy_id = "EventBridgeEncryptUsingKey"

  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

module "sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"
  count   = local.create_sns_topic ? 1 : 0

  attributes        = ["securityhub"]
  subscribers       = var.subscribers
  sqs_dlq_enabled   = false
  kms_master_key_id = local.create_sns_topic ? module.sns_kms_key[0].alias_name : ""

  allowed_aws_services_for_sns_published = ["events.amazonaws.com"]

  context = module.this.context
}

module "imported_findings_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["securityhub-imported-findings"]
  context    = module.this.context
}

resource "aws_cloudwatch_event_rule" "imported_findings" {
  count       = local.enable_notifications == true ? 1 : 0
  name        = module.imported_findings_label.id
  description = "SecurityHubEvent - Imported Findings"
  tags        = module.this.tags

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.securityhub"
      ],
      "detail-type" : [
        var.cloudwatch_event_rule_pattern_detail_type
      ]
    }
  )
}

resource "aws_cloudwatch_event_target" "imported_findings" {
  count = local.enable_notifications == true ? 1 : 0
  rule  = aws_cloudwatch_event_rule.imported_findings[0].name
  arn   = local.imported_findings_notification_arn
}
