#Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Calling RemoteState based on the Environments
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${lower(var.env)}-s3-acsgroup10"
    key    = "${lower(var.env)}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(
    var.default_tags,
    { "env" = var.env }
  )
  name_prefix = "${var.acs_group}-${var.env}"
}

# Provision SSH key pair for the instances
resource "aws_key_pair" "sshKey" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}

# Creating BastionServer
resource "aws_instance" "bastionServer" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.sshKey.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.publicSG.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      Name = "${local.name_prefix}-Bastion"
    }
  )
}

# Creating launch template during autoscaling
resource "aws_launch_template" "amazonWebserver" {
  name_prefix            = "${local.name_prefix}-Webserver"
  image_id               = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.privateSG.id]
  key_name               = aws_key_pair.sshKey.key_name
  iam_instance_profile {
    name = "LabInstanceProfile"
  }
  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", 
    { 
      env=var.env
    }
  )
  )
  
  lifecycle{
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      Name = "${local.name_prefix}-Webserver"
    }
  )
}

# AutoScalingGroup for the instances
resource "aws_autoscaling_group" "amazonServerASG" {
  name                = "${local.name_prefix}-Webserver-ASG"
  vpc_zone_identifier = tolist(data.terraform_remote_state.network.outputs.private_subnet_ids)
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  target_group_arns = [aws_lb_target_group.targetGroup.arn]
  launch_template {
    id      = aws_launch_template.amazonWebserver.id
    version = "$Latest"
  }
  
  tag {
    key = "Name"
    value = "${local.name_prefix}-Webserver"
    propagate_at_launch = true
    }
}

# Scale out policy for AutoScalingGroup
resource "aws_autoscaling_policy" "scaleOutPolicy" {
  name                   = "${local.name_prefix}-Scale-Out-Policy"
  autoscaling_group_name = aws_autoscaling_group.amazonServerASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
}

# Parameters set for the ScaleOutPolicy
resource "aws_cloudwatch_metric_alarm" "scaleOutAlarm" {
  alarm_name          = "${local.name_prefix}-Scale-Out-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = "10"
  period              = "60"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.amazonServerASG.name
  }
  alarm_description = "This alarm will trigger the scale-out policy if the average CPU utilization crosses 10% for 60 seconds"
  alarm_actions     = [aws_autoscaling_policy.scaleOutPolicy.arn]
}

# Scale in policy for AutoScalingGroup
resource "aws_autoscaling_policy" "scaleInPolicy" {
  name                   = "${local.name_prefix}-Scale-In-Policy"
  autoscaling_group_name = aws_autoscaling_group.amazonServerASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
}

# Parameters set for the ScaleInPolicy
resource "aws_cloudwatch_metric_alarm" "scaleInAlarm" {
  alarm_name          = "${local.name_prefix}-Scale-In-Alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = "5"
  period              = "60"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.amazonServerASG.name
  }
  alarm_description = "This alarm will trigger the scale-in policy if the average CPU utilization is less than 5% for 60 seconds"
  alarm_actions     = [aws_autoscaling_policy.scaleInPolicy.arn]
}