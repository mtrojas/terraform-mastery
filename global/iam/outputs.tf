output "all_users" {
  value = aws_iam_user.tf_users
}

output "all_arns" {
  value = values(aws_iam_user.tf_users)[*].arn
}

# Loop over a list and perform an action over every item and output the list
output "family_names" {
  description = "Names of my brothers and sisters"
  value       = [for name in var.family_names : upper(name)]
}

# Loop over a list and filter the list output
output "long_family_names" {
  description = "Names of my brothers and sisters"
  value       = [for name in var.family_names : name if length(name) > 5]
}

# Loop over a map and output a list
output "bios" {
  value = [for name, beauty in var.family_beauty : "${name} is ${beauty}"]
}

# Loop over a list and output a map
output "new_map" {
  value = { for name in var.family_names : name => length(name) }
}

# Loop over a map and output a map
output "map_map" {
  value = { for name, beauty in var.family_beauty : upper(name) => upper(beauty) }
}
