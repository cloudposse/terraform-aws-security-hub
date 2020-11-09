# -----------------------------------------------------------------------------------------------------------------------
# Subscribe the Acccount to Security Hub
# -----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_account" "enable_us_east_1" {
  count = module.this.enabled ? 1 : 0
}

# -----------------------------------------------------------------------------------------------------------------------
# Optionally subscribe to Security Hub Standards 
# https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards.html
# -----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_standards_subscription" "enable_cis_1_2_0" {
  count         = module.this.enabled && var.enable_cis_1_2_0 ? 1 : 0
  depends_on    = [aws_securityhub_account.enable_us_east_1]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_standards_subscription" "enable_foundations_1_0_0" {
  count         = module.this.enabled && var.enable_foundations_1_0_0 ? 1 : 0
  depends_on    = [aws_securityhub_account.enable_us_east_1]
  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "enable_pci_dss_3_2_1" {
  count         = module.this.enabled && var.enable_pci_dss_3_2_1 ? 1 : 0
  depends_on    = [aws_securityhub_account.enable_us_east_1]
  standards_arn = "arn:aws:securityhub:us-east-1::standards/pci-dss/v/3.2.1"
}
