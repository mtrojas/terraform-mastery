variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

variable "give_neo_cloudwatch_full_access" {
  description = "If true, neo gets full access to CloudWatch"
  type        = bool
}

variable "family_names" {
  description = "My brothers' and sisters' names"
  type        = list(string)
  default     = ["rene", "isabel", "sofia", "magdalena", "santiago"]
}

variable "family_beauty" {
  description = "Some of the beauty my siblings have"
  type        = map(string)
  default = {
    rene      = "generous"
    isabel    = "friendly"
    sofia     = "intuition"
    magdalena = "honesty"
    santiago  = "smart"
  }

}
