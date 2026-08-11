resource "aws_key_pair" "create" {
    key_name = "create"
    public_key = file("create.pub")
  
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
locals {
  instance_sgs = {
    frontend = [aws_security_group.frontend.id]
    backend  = [aws_security_group.backend.id]
    database = [aws_security_group.db.id]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  for_each = tomap({
    backend  = module.vpc.private_subnets[0]
    database = module.vpc.private_subnets[0]
    frontend = module.vpc.public_subnets[0]
  })

  name = each.key
  instance_type = "t3.micro"
  key_name      = "create"
  monitoring    = true
  subnet_id     = each.value
  ami = data.aws_ami.ubuntu.id
  vpc_security_group_ids = local.instance_sgs[each.key]
  user_data = each.key == "frontend" ? file("frontend.sh") : ""
  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}