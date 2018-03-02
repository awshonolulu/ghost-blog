module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${var.service}-${var.service_instance}-ASG"

  key_name = "${var.ssh_key_name}"
  # Launch configuration
  lc_name = "${var.service}-${var.service_instance}-lc"

  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ghost-server.id}"]

  #ebs_block_device = [
  #  {
  #    device_name           = "/dev/xvdz"
  #    volume_type           = "gp2"
  #    volume_size           = "50"
  #    delete_on_termination = true
  #  },
  #]

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.service}-${var.service_instance}-asg"
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  tags = [
    {
      key                 = "Provisioner"
      value               = "Terraform"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "${var.service_owner}"
      propagate_at_launch = true
    },
    {
      key                 = "Stage"
      value               = "${var.service_stage}"
      propagate_at_launch = true
    },
    {
      key                 = "Service"
      value               = "${var.service_instance}"
      propagate_at_launch = true
    },
    {
      key                 = "Instance"
      value               = "${var.service_instance}"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.service}-${var.service_instance}-web"
      propagate_at_launch = true
    },
  ]
}
