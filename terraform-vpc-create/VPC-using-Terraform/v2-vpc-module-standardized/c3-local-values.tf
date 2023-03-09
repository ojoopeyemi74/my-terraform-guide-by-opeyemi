# Define Local Values in Terraform

locals {
  owners = var.business_division
  enviroment = var.enviroment
  name = "${var.business_division}-${var.enviroment}"
  #name = "${local.owners}-${local.enviroment}"
  common_tags = {
    owners = local.owners
    enviroment = local.enviroment
  }
}