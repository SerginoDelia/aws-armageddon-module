resource "aws_launch_template" "lt" {
  for_each      = {for k,v in var.network.vpcs : k => {
    name = k
    instance_type = "t2.micro"
    resource_type = "instance"
    user-data = base64encode(file("user-data.sh"))
  }}
  name          = each.key
  image_id      = data.aws_ami.ami.id
  instance_type = each.value.instance_type
  key_name      = aws_key_pair.key-pair[each.key].key_name
  vpc_security_group_ids = [aws_security_group.sg[each.key].id]
  user_data = each.value.user-data
  tag_specifications {
    resource_type = each.value.resource_type
    tags = {
      Name = "${each.key}-lt"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  for_each = var.network.vpcs
  name     = "${each.key}-asg"
  # availability_zones   = []
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier = [for k,v in var.network.subnets : aws_subnet.subnets[k].id]
#   

  launch_template {
    id      = aws_launch_template.lt[each.key].id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${each.key}-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = var.network.subnets
  name     = "${each.key}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpcs[each.value.vpc].id
}

resource "aws_lb" "lb" {
  for_each           = var.network.vpcs
  name               = "${each.key}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg[each.key].id]
  subnets            = [for k,v in var.network.subnets : aws_subnet.subnets[k].id]
  enable_deletion_protection = false

  tags = {
    Name    = "${each.key}-lb"
  }
}

