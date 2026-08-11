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