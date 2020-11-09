provider "aws" {
  region = var.region
}

module "example" {
  source = "../.."

  enable_cis_1_2_0 = var.enable_cis_1_2_0
  context          = module.this.context
}
