module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.service}-${var.service_instance}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 20

  name     = "${var.service}${var.service_instance}"
  username = "${var.mysql_user}"
  password = "${var.mysql_pass}"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["${aws_security_group.ghost-rds.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"

  monitoring_role_name   = "${var.service}-${var.service_instance}-monitoring-role"
  create_monitoring_role = true

  tags = {
    Owner       = "${var.service_owner}"
    Provisioner = "Terraform"
    Stage       = "${var.service_stage}"
    Service     = "${var.service}"
    Instance    = "${var.service_instance}"
  }

  # DB subnet group
  subnet_ids = ["${module.vpc.database_subnets}"]

  multi_az = true

  # DB parameter group
  family = "mysql5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.service}-${var.service_instance}-rds-snapshot-final"

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
  ]
}
