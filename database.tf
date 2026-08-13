resource "aws_db_instance" "default" {
  allocated_storage = 10

  db_name = var.name

  engine         = var.engine
  engine_version = "8.0"

  instance_class = var.instanceslass
  db_subnet_group_name = aws_db_subnet_group.mysql.name

  username = var.username
  password = var.password

  parameter_group_name = "default.mysql8.0"

  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.db.id
  ]

  publicly_accessible = false
}