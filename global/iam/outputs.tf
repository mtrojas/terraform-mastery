output "all_users" {
  value = aws_iam_user.tf_users
}

output "all_arns" {
  value = values(aws_iam_user.tf_users)[*].arn
}

output "family_names" {
  description = "Names of my brothers and sisters"
  value       = [for name in var.family_names : upper(name)]
}

output "long_family_names" {
  description = "Names of my brothers and sisters"
  value       = [for name in var.family_names : name if length(name) > 5]
}

output "bios" {
  value = [for name, beauty in var.family_beauty : "${name} is ${beauty}"]
}

output "new_map" {
  value = { for name in var.family_names : name => length(name) }
}
