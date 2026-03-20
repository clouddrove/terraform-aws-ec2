# Wrapper Module for Terragrunt

This module provides a wrapper around the root module to allow creating multiple instances using `for_each`, which is particularly useful with Terragrunt.

## Usage with Terragrunt

```hcl
terraform {
  source = "clouddrove/terraform-aws-ec2//wrappers"
}

inputs = {
  defaults = {
    environment = "production"
    label_order = ["name", "environment"]
  }

  items = {
    instance1 = {
      name = "first"
    }
    instance2 = {
      name = "second"
      environment = "staging"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| items | Map of items to create multiple module instances | `any` | `{}` |
| defaults | Default values for module instances | `any` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| wrapper | Map of all module instance outputs |
