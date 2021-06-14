
module "webapp-vpc" {
  source      = "../../../module/vpc"
  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

module "weapp-rds" {
  source      = "../../../module/rds"
  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

resource "aws_launch_configuration" "webapp-launch-configuration" {
  name            = "webapp-launch_config_webserver"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.INSTANCE_TYPE
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
  security_groups = [aws_security_group.webapp-server-sg.id]
  key_name        = aws_key_pair.key.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
}

resource "aws_autoscaling_group" "webapp-webservers-asg" {
  name                      = "webapp-webservers-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.webapp-launch-configuration.name
  vpc_zone_identifier = [
    "${module.webapp-vpc.webapp_out_public_subnet1_id}",
    "${module.webapp-vpc.webapp_out_public_subnet2_id}",
  ]
  target_group_arns = [aws_lb_target_group.webapp-lb-target-group.arn]
}

resource "aws_security_group" "webapp-server-sg" {
  name        = "${var.ENVIRONMENT}-webapp-server-sg"
  description = "Created by Dbatista"
  vpc_id      = module.webapp-vpc.webapp_out_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "webapp-app-lb" {
  name               = "${var.ENVIRONMENT}-webapp-applb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp-webservers-alb.id]
  subnets = [
    "${module.webapp-vpc.webapp_out_public_subnet1_id}",
    "${module.webapp-vpc.webapp_out_public_subnet2_id}"
  ]
}

# Add Target Group
resource "aws_lb_target_group" "webapp-lb-target-group" {
  name     = "webapp-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.webapp-vpc.webapp_out_vpc_id
}

# Adding HTTP listener
resource "aws_lb_listener" "web-appwebserver_listener" {
  load_balancer_arn = aws_lb.webapp-app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.webapp-lb-target-group.arn
    type             = "forward"
  }
}

resource "aws_security_group" "webapp-webservers-alb" {
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-webservers-alb-ALB"
  }
  name        = "${var.ENVIRONMENT}-webapp-webservers-alb-ALB"
  description = "Created by Dbatista"
  vpc_id      = module.webapp-vpc.webapp_out_vpc_id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "key-pub"
  public_key = file("../../../../.secret/key.pub")
}
