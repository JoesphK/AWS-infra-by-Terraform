resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for service in var.assume_services : {
        Effect = "Allow"
        Principal = {
          Service = service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach managed policies
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)
  role     = aws_iam_role.this.name
  policy_arn = each.value
}

# create instance profile for NodeGroup roles
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.role_name
  role  = aws_iam_role.this.name
}
