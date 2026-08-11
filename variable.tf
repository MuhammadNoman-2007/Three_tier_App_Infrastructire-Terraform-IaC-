variable "env" {
  default = "dev"
  description = "The environment name"
  type        = string
}
variable "CIDR" {
    default = "0.0.0.0/0"
    description = "The CIDR block for the security group"
    type        = string
}
variable "name" {
  default = "myd"
  description = "The name of the database"
  type        = string
}
variable "engine" {
  default = "mysql"
  description = "The database engine"
  type        = string
}
variable "instanceslass" {        
  default = "db.t3.micro"
  description = "The instance class for the database"
  type        = string
}
variable "username" {
  default = "test"
  description = "The username for the database"
  type        = string
}
variable "password" {
  default = "test123"
  description = "The password for the database"
  type        = string
}

