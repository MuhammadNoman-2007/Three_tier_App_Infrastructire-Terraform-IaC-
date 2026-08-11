resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = var.name
  engine               = var.engine
  engine_version       = "8.0"
  instance_class       = var.instanceslass
  username             = var.username
  password             = vaar.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}