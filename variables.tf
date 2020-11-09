# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults set that can be overridden for desired behavior.
# ---------------------------------------------------------------------------------------------------------------------
variable "enable_cis_1_2_0" {
  description = "Flag to indicate if the account should be subscribed to the CIS v1.2.0 standard"
  type        = bool
  default     = false
}

variable "enable_foundations_1_0_0" {
  description = "Flag to indicate if the account should be subscribed to the AWS Foundations Benchmark v1.0.0 standard"
  type        = bool
  default     = false
}

variable "enable_pci_dss_3_2_1" {
  description = "Flag to indicate if the account should be subscribed to the PCI v3.2.1 standard"
  type        = bool
  default     = false
}
