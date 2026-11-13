variables {
}

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect    = "Allow"
          Principal = { AWS = "arn:aws:iam::123456789012:root" }
          Action    = "kms:*"
          Resource  = "*"
        }]
      })
    }
  }
}

run "validate_module" {
  command = plan
}
