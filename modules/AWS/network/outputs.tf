# Return maps of public and private subnets
output "public_subnets" {
  description = "Map of public subnet IDs"
  value       = { for k, subnet in aws_subnet.public : k => subnet.id }
}

output "private_subnets" {
  description = "Map of private subnet IDs"
  value       = { for k, subnet in aws_subnet.private : k => subnet.id }
}

output "vpc_id" {
  value = aws_vpc.main.id
}
