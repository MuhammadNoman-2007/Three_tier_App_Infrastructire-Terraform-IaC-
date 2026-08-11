resource "aws_key_pair" "create" {
    key_name = "create"
    public_key = file("create.pub")
  
}

resource "aws_security_group" "secure" {
  name        = "${var.env}-security"
  description = "This is the security group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
    Environment = var.env
  }
}
#  SSH (port 22)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.secure.id
  cidr_ipv4         = var.CIDR
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

#  HTTP (port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.secure.id
  cidr_ipv4         = var.CIDR
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

#  Allow all outbound
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.secure.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
# Accesing ami_id from pc
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical (Ubuntu official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  for_each = tomap ({
    "backend" = module.vpc.private_subnets[0]
    "database" = module.vpc.private_subnets[0]
    "frontend" = module.vpc.public_subnets[0]
  })
  name = each.key
  instance_type = "t3.micro"
  key_name      = "create"
  monitoring    = true
  subnet_id     = each.value
  ami = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.secure.id] 
  user_data = each.key == "frontend" ? file("frontend.sh") : 0
  tags = {
  Terraform   = "true"
  Environment = var.env
  }
}