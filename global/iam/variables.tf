variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "morpheus"]
}

variable "family_names" {
  description = "My brothers' and sisters' names"
  type        = list(string)
  default     = ["rene", "isabel", "sofia", "magdalena", "santiago"]
}
