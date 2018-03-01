module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.service}-${var.service_instance}"
  cidr = "${var.vpc_cidr}"

  azs = ["${var.availability_zones}"]

  private_subnets = ["${var.vpc_private_subnets}"]
  public_subnets  = ["${var.vpc_public_subnets}"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  private_subnet_tags = {
    Layer = "private"
  }

  public_subnet_tags = {
    Layer = "public"
  }

  tags = {
    Provisioner = "Terraform"
    Stage       = "${var.service_stage}"
    Service     = "${var.service}"
    Instance    = "${var.service_instance}"
  }
}
