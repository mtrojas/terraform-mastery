output "all_users" {
  value = aws_iam_user.tf_users
}

output "all_arns" {
  value = values(aws_iam_user.tf_users)[*].arn
}

