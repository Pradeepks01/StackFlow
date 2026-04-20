resource "aws_db_instance" "stackflow_db" {
  allocated_storage    = 20
  storage_type         = "gp3"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  db_name              = "stackflow"
  username             = "admin"
  password             = aws_secretsmanager_secret_version.db_secret_value.secret_string
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  storage_encrypted    = true
  multi_az             = false
  backup_retention_period = 3
  deletion_protection  = false  # easy cleanup after demo

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.stackflow_db_subnet.name

  tags = {
    Environment = var.environment
    Project     = "StackFlow"
  }
}

# secrets manager for db password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "stackflow-db-password"

  tags = {
    Environment = var.environment
    Project     = "StackFlow"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = var.db_password
}

resource "aws_db_subnet_group" "stackflow_db_subnet" {
  name       = "stackflow-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name   = "stackflow-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}
