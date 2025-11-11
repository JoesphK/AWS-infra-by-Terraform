output "instances" {
  description = "Map of instance name => instance object"
  value = aws_instance.this
}

output "public_ips" {
  value = { for name, inst in aws_instance.this : name => inst.public_ip }
}

output "private_ips" {
  value = { for name, inst in aws_instance.this : name => inst.private_ip }
}
