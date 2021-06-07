


resource "aws_db_instance" "db-inst01-mariadb" {
  allocated_storage       = 20 # 20 GB
  engine                  = "mariadb"
  engine_version          = "10.4.8"
  instance_class          = "db.t2.micro"
  identifier              = "mariadb"
  name                    = "mariadb"
  username                = "root"
  password                = "marialovesme"
  db_subnet_group_name    = aws_db_subnet_group.db-inst01-subnets.name
  parameter_group_name    = aws_db_parameter_group.db-inst01-parameter-group.name
  multi_az                = "false"
  vpc_security_group_ids  = [aws_security_group.db-inst01-sg.id]
  storage_type            = "gp2"
  backup_retention_period = 30
  availability_zone       = data.aws_subnet.private01.availability_zone
  skip_final_snapshot     = "true"
  tags = {
    Name = "db-inst01-mariadb"
  }
}


resource "aws_db_parameter_group" "db-inst01-parameter-group" {
  name        = "levelup-mariadb-parameters"
  family      = "mariadb10.4"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}


# Security Group for MariaDB
resource "aws_security_group" "db-inst01-sg" {
  vpc_id      = aws_vpc.main.id
  name        = "db-inst01-sg"
  description = "security group for Maria DB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.ssh.id]
  }

  tags = {
    Name = "allow-mariadb"
  }
}
