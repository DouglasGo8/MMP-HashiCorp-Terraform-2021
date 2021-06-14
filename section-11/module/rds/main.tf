
module "webapp-vpc" {
  source      = "../vpc"
  ENVIRONMENT = var.ENVIRONMENT
}

resource "aws_db_instance" "webapp-rds" {
  identifier              = "${var.ENVIRONMENT}-webapp-rds"
  allocated_storage       = var.WEBAPP_RDS_ALLOCATED_STORAGE
  storage_type            = "gp2"
  engine                  = var.LEVELUP_RDS_ENGINE
  engine_version          = var.LEVELUP_RDS_ENGINE_VERSION
  instance_class          = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible     = var.PUBLICLY_ACCESSIBLE
  username                = var.LEVELUP_RDS_USERNAME
  password                = var.LEVELUP_RDS_PASSWORD

  vpc_security_group_ids = [aws_security_group.webapp-rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.webapp-rds-subnet-gp.name
  multi_az               = "false"
}


resource "aws_security_group" "webapp-rds-sg" {
  name        = "${var.ENVIRONMENT}-webapp-rds-sg"
  description = "Created by Dbatista"
  vpc_id      = module.webapp-vpc.webapp_out_vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ENVIRONMENT}-webapp-rds-sg"
  }
}

resource "aws_db_subnet_group" "webapp-rds-subnet-gp" {
  name        = "${var.ENVIRONMENT}-webapp-rds-subnet-gp"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids = [
    "${module.webapp-vpc.webapp_out_private_subnet1_id}",
    "${module.webapp-vpc.webapp_out_private_subnet2_id}",
  ]
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-rds-subnet-gp"
  }
}


