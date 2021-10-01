terraform {
  backend "s3" {
    key = "global/iam/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "tf_users" {
  for_each = toset(var.user_names)
  name     = each.value
}

# IAM Policy that allow read-only access to CloudWatch
resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
  count = var.give_neo_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.tf_users["neo"].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

# IAM Policy that allows full (read and write) access to CloudWatch
resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
  count = var.give_neo_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.tf_users["neo"].name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn

}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

