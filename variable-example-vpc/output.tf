output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.myvpc.id
}

output "app_subnet_id" {
  description = "The ID of the app subnet"
  value       = aws_subnet.app_subnet.id
}

output "work_subnet_id" {
  description = "The ID of the work subnet"
  value       = aws_subnet.work_subnet.id
}
