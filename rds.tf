resource "aws_db_subnet_group" "mysql" {
  name = "${var.env}-mysql-subnet-group"

  subnet_ids = [
    module.vpc.private_subnets[0],
    module.vpc.private_subnets[1]
  ]

  tags = {
    Name        = "${var.env}-mysql-subnet-group"
    Environment = var.env
  }
}

