

resource "aws_launch_configuration" "asg-insts01-launch-config" {
  name_prefix   = "asg-insts-01-lauchconfig"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
}

resource "aws_autoscaling_group" "asg-insts01" {
  name_prefix               = "asg-insts01"
  vpc_zone_identifier       = [data.aws_subnet.main-public-1.id, data.aws_subnet.main-public-2.id]
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg-insts01-cpu-policy" {
  name                   = "asg-insts01-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.asg-insts01.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "asg-insts01-cpu-alarm" {
  alarm_name          = "asg-insts01-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.asg-insts01-cpu-policy.arn]
}

resource "aws_autoscaling_policy" "asg-insts01-cpu-policy-scaledown" {
  name                   = "asg-insts01-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.asg-insts01-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "asg-insts01-cpu-alarm-scaledown" {
  alarm_name          = "asg-insts01-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" # seconds
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg-insts01-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.asg-insts01-cpu-policy-scaledown.arn]
}

resource "aws_key_pair" "key" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
