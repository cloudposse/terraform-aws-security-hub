# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# The module expects values to be supplied for these paramaters.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  type        = string
  description = "AWS region"
}

variable "enable_cis_1_2_0" {
  description = "Flag to indicate if the account should be subscribed to the CIS v1.2.0 standard"
  type        = bool
}
