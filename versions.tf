terraform {
  required_version = ">= 0.12.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.58"
    }
  }
}
