module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.service}-${var.service_instance}"
  cidr = "${var.vpc_cidr}"

  azs = ["${var.availability_zones}"]

  private_subnets  = ["${var.vpc_private_subnets}"]
  public_subnets   = ["${var.vpc_public_subnets}"]
  database_subnets = ["${var.vpc_database_subnets}"]

  enable_nat_gateway           = true
  enable_vpn_gateway           = false
  create_database_subnet_group = true

  private_subnet_tags = {
    Layer = "private"
  }

  public_subnet_tags = {
    Layer = "public"
  }

  tags = {
    Owner       = "${var.service_owner}"
    Provisioner = "Terraform"
    Stage       = "${var.service_stage}"
    Service     = "${var.service}"
    Instance    = "${var.service_instance}"
  }
}

resource "aws_security_group" "ghost-server" {
  name        = "${var.service}-${var.service_instance}-web-sg"
  description = "Allow SSH inbound, HTTP(s) inbound from elb, and all outbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.service_ip_whitelist}"]
  }

  ingress {
    from_port       = 2368
    to_port         = 2368
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ghost-elb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ghost-rds" {
  name        = "${var.service}-${var.service_instance}-rds-sg"
  description = "Allow MySQL inbound from ${var.service}-${var.service_instance} instances"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ghost-server.id}"]
  }
}

resource "aws_security_group" "ghost-elb" {
  name        = "${var.service}-${var.service_instance}-elb-sg"
  description = "Allow all HTTP(s) inbound"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
