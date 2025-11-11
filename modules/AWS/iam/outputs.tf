output "role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.this.name
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN (if created)"
  value       = length(aws_iam_instance_profile.this) > 0 ? aws_iam_instance_profile.this[0].arn : ""
}
