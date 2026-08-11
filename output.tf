output "instances_dns"{
    value = { for instance in aws_instance.web : instance.name => instance.public_dns }
}
