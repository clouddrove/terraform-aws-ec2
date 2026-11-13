mock_provider "aws" {
  mock_data "aws_ami" {
    defaults = {
      id = "ami-mock-lookup"
    }
  }

  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
    }
  }
}

run "ami_id_only_skips_lookup" {
  command = plan

  variables {
    instance_count        = 1
    subnet_ids            = ["subnet-mock"]
    enable_security_group = false
    kms_key_enabled       = false
    instance_configuration = {
      ami_id        = "ami-explicit"
      instance_type = "t3.micro"
    }
  }

  assert {
    condition     = length(data.aws_ami.amazon) == 0 && length(data.aws_ami.ubuntu) == 0
    error_message = "An explicit AMI ID must skip both AMI lookups."
  }

  assert {
    condition     = aws_instance.default[0].ami == "ami-explicit"
    error_message = "The instance must use the explicit AMI ID."
  }
}

run "ami_id_and_ubuntu_skips_lookup" {
  command = plan

  variables {
    instance_count        = 1
    subnet_ids            = ["subnet-mock"]
    enable_security_group = false
    kms_key_enabled       = false
    instance_configuration = {
      ami_id        = "ami-explicit-ubuntu"
      instance_type = "t3.micro"
      ami = {
        type = "ubuntu"
      }
    }
  }

  assert {
    condition     = length(data.aws_ami.amazon) == 0 && length(data.aws_ami.ubuntu) == 0
    error_message = "An explicit AMI ID must skip both lookups even when ami.type is ubuntu."
  }

  assert {
    condition     = aws_instance.default[0].ami == "ami-explicit-ubuntu"
    error_message = "The instance must use the explicit AMI ID."
  }
}

run "al2023_uses_amazon_lookup" {
  command = plan

  variables {
    instance_count        = 1
    subnet_ids            = ["subnet-mock"]
    enable_security_group = false
    kms_key_enabled       = false
    instance_configuration = {
      instance_type = "t3.micro"
      ami = {
        type         = "al2023"
        architecture = "x86_64"
      }
    }
  }

  assert {
    condition     = length(data.aws_ami.amazon) == 1 && length(data.aws_ami.ubuntu) == 0
    error_message = "Amazon Linux selection must run only the Amazon AMI lookup."
  }

  assert {
    condition     = aws_instance.default[0].ami == "ami-mock-lookup"
    error_message = "The instance must use the mocked Amazon AMI."
  }
}

run "ubuntu_uses_ubuntu_lookup" {
  command = plan

  variables {
    instance_count        = 1
    subnet_ids            = ["subnet-mock"]
    enable_security_group = false
    kms_key_enabled       = false
    instance_configuration = {
      instance_type = "t3.micro"
      ami = {
        type         = "ubuntu"
        architecture = "x86_64"
        version      = "22.04"
      }
    }
  }

  assert {
    condition     = length(data.aws_ami.amazon) == 0 && length(data.aws_ami.ubuntu) == 1
    error_message = "Ubuntu selection must run only the Ubuntu AMI lookup."
  }

  assert {
    condition     = aws_instance.default[0].ami == "ami-mock-lookup"
    error_message = "The instance must use the mocked Ubuntu AMI."
  }
}

run "invalid_ami_type_fails_validation" {
  command = plan

  variables {
    instance_configuration = {
      instance_type = "t3.micro"
      ami = {
        type         = "debian"
        architecture = "x86_64"
      }
    }
  }

  expect_failures = [var.instance_configuration]
}
