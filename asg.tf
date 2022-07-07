resource "aws_launch_template" "launch-template" {
  name                   = "${var.COMPONENT}-${var.ENV}"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.NODE_TYPE
  vpc_security_group_ids = [aws_security_group.main.id]
  target_group_arn       = aws_lb_target_group.target-group.arn

  iam_instance_profile {
    name = var.IAM_POLICY_CREATE ? aws_iam_instance_profile.instance-profile.*.name[0] : null
  }

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.COMPONENT}-${var.ENV}"
    }
  }

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }

  #user_data = filebase64("${path.module}/example.sh")
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.COMPONENT}-${var.ENV}"
  desired_capacity    = var.CAPACITY_NODES
  max_size            = var.MAX_NODES
  min_size            = var.MIN_NODES
  vpc_zone_identifier = var.SUBNET_IDS

  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.COMPONENT}-${var.ENV}"
    propagate_at_launch = true
  }
}
