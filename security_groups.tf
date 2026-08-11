# Frontend SG (nginx)
resource "aws_security_group" "frontend" {
  name   = "${var.env}-frontend-sg"
  vpc_id = module.vpc.vpc_id

  description = "Allow HTTP from the world and SSH from admin CIDR"
  tags = { Environment = var.env }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.CIDR]   # your admin IP/CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Backend SG (only allow from frontend + admin SSH)
resource "aws_security_group" "backend" {
  name   = "${var.env}-backend-sg"
  vpc_id = module.vpc.vpc_id

  tags = { Environment = var.env }

  ingress {
    from_port                = 8080           # app port
    to_port                  = 8080
    protocol                 = "tcp"
    security_groups          = [aws_security_group.frontend.id]  # allow frontend
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.CIDR]  # admin SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB SG (only allow DB port from backend SG)
resource "aws_security_group" "db" {
  name   = "${var.env}-db-sg"
  vpc_id = module.vpc.vpc_id
  tags = { Environment = var.env }

  ingress {
    from_port                = 3306           # example MySQL
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}