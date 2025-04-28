output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet[*].id
}

output "instance_ids" {
  value = aws_instance.my_instances[*].id
}
