#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-ec2"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : EC2 Module
# Description : Terraform EC2 module variables.
variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control module creation."
}

variable "instance_configuration" {
  description = "Configuration options for the EC2 instance"
  type = object({
    ami = optional(object({
      type         = string           # al1, al2, al2023, ubuntu
      version      = optional(string) # Only for ubuntu
      architecture = string           # arm64 or x86_64
      region       = string
    }), null)
    ebs_optimized                        = optional(bool, false)
    instance_type                        = string
    monitoring                           = optional(bool, false)
    associate_public_ip_address          = optional(bool, true)
    disable_api_termination              = optional(bool, false)
    instance_initiated_shutdown_behavior = optional(string, "stop")
    placement_group                      = optional(string, "")
    tenancy                              = optional(string, "default")
    host_id                              = optional(string, null)
    user_data                            = optional(string, "")
    user_data_base64                     = optional(string, null)
    user_data_replace_on_change          = optional(bool, null)
    availability_zone                    = optional(string, null)
    get_password_data                    = optional(bool, null)
    private_ip                           = optional(string, null)
    secondary_private_ips                = optional(list(string), null)
    source_dest_check                    = optional(bool, true)
    ipv6_address_count                   = optional(number, null)
    ipv6_addresses                       = optional(list(string), null)
    hibernation                          = optional(bool, false)
    root_block_device                    = optional(list(any), [])
    ephemeral_block_device               = optional(list(any), [])
  })
  default = {
    instance_type = "t4g.small" # Providing a default instance type
  }
}

variable "assign_eip_address" {
  type        = bool
  default     = true
  description = "Assign an Elastic IP address to the instance."
  sensitive   = true
}

variable "ebs_iops" {
  type        = number
  default     = 0
  description = "Amount of provisioned IOPS. This must be set with a volume_type of io1."
}

variable "ebs_device_name" {
  type        = list(string)
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
  description = "Name of the EBS device to mount."
}

variable "ebs_volume_size" {
  type        = number
  default     = 30
  description = "Size of the EBS volume in gigabytes."
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp3"
  description = "The type of EBS volume. Can be standard, gp3 or io1."
}

variable "default_instance_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the instance creation."
}

variable "ebs_volume_enabled" {
  type        = bool
  default     = false
  description = "Flag to control the ebs creation."
}
variable "instance_profile_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the instance profile creation."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of VPC Subnet IDs to launch in."
  sensitive   = true
}

variable "instance_count" {
  type        = number
  default     = 0
  description = "Number of instances to launch."
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}


variable "iam_instance_profile" {
  type        = string
  default     = null
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
}

variable "cpu_credits" {
  type        = string
  default     = "standard"
  description = "The credit option for CPU usage. Can be `standard` or `unlimited`. T3 instances are launched as unlimited by default. T2 instances are launched as standard by default."
}

variable "instance_tags" {
  type        = map(any)
  default     = {}
  description = "Instance tags."
}
variable "spot_instance_tags" {
  type        = map(any)
  default     = {}
  description = "Instance tags."
}

variable "dns_zone_id" {
  type        = string
  default     = "Z1XJD7SSBKXLC1"
  description = "The Zone ID of Route53."
  sensitive   = true
}

variable "dns_enabled" {
  type        = bool
  default     = false
  description = "Flag to control the dns_enable."
}

variable "hostname" {
  type        = string
  default     = "ec2"
  description = "DNS records to create."
  sensitive   = true
}

variable "type" {
  type        = string
  default     = "CNAME"
  description = "Type of DNS records to create."
}

variable "ttl" {
  type        = string
  default     = "300"
  description = "The TTL of the record to add to the DNS zone to complete certificate validation."
}

variable "metadata_http_tokens_required" {
  type        = string
  default     = "optional"
  description = "Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Valid values include optional or required. Defaults to optional."
}

variable "metadata_http_endpoint_enabled" {
  type        = string
  default     = "enabled"
  description = "Whether the metadata service is available. Valid values include enabled or disabled. Defaults to enabled."
}

variable "metadata_http_put_response_hop_limit" {
  type        = number
  default     = 2
  description = "The desired HTTP PUT response hop limit (between 1 and 64) for instance metadata requests."
}

variable "instance_metadata_tags_enabled" {
  type        = string
  default     = "disabled"
  description = "Whether the metadata tag is available. Valid values include enabled or disabled. Defaults to enabled."
}

variable "multi_attach_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Amazon EBS Multi-Attach. Multi-Attach is supported on io1 and io2 volumes."
}

variable "kms_key_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the kms is enabled or disabled."
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true."
}

variable "alias" {
  type        = string
  default     = "alias/ec2-test"
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash."
}

variable "kms_description" {
  type        = string
  default     = "Parameter Store KMS master key"
  description = "The description of the key as viewed in AWS console."
}

variable "key_usage" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  sensitive   = true
  description = "Specifies the intended use of the key. Defaults to ENCRYPT_DECRYPT, and only symmetric encryption and decryption are supported."
}

variable "deletion_window_in_days" {
  type        = number
  default     = 7
  description = "Duration in days after which the key is deleted after destruction of the resource."
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether the key is enabled."
}

variable "enable_key_rotation" {
  type        = string
  default     = true
  description = "Specifies whether key rotation is enabled."
}

variable "customer_master_key_spec" {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT."
  sensitive   = true
}

variable "kms_multi_region" {
  type        = bool
  default     = false
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key."
}
variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}

variable "allowed_ip" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "List of allowed ip."
}

variable "allowed_ports" {
  type        = list(any)
  default     = [80, 443]
  description = "List of allowed ingress ports"
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol. If not icmp, tcp, udp, or all use the."
}

variable "enable_security_group" {
  type        = bool
  default     = true
  description = "Enable default Security Group with only Egress traffic allowed."
}

variable "egress_rule" {
  type        = bool
  default     = true
  description = "Enable to create egress rule"
}

variable "is_external" {
  type        = bool
  default     = false
  description = "enable to udated existing security Group"
}

variable "sg_ids" {
  type        = list(any)
  default     = []
  description = "of the security group id."
}

variable "sg_description" {
  type        = string
  default     = "Instance default security group (only egress access is allowed)."
  description = "The security group description."
}
variable "sg_egress_description" {
  type        = string
  default     = "Description of the rule."
  description = "Description of the egress and ingress rule"
}

variable "sg_egress_ipv6_description" {
  type        = string
  default     = "Description of the rule."
  description = "Description of the egress_ipv6 rule"
}

variable "sg_ingress_description" {
  type        = string
  default     = "Description of the ingress rule use elasticache."
  description = "Description of the ingress rule"
}

variable "ssh_allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}

variable "ssh_allowed_ports" {
  type        = list(any)
  default     = []
  description = "List of allowed ingress ports"
}

variable "ssh_protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol. If not icmp, tcp, udp, or all use the."
}

variable "ssh_sg_ingress_description" {
  type        = string
  default     = "Description of the ingress rule use elasticache."
  description = "Description of the ingress rule"
}

### key-pair #####

variable "enable_key_pair" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable key pair."
}

variable "public_key" {
  type        = string
  default     = ""
  description = "Name  (e.g. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`)."
  sensitive   = true
}

###### spot
variable "spot_instance_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the instance creation."
}

variable "spot_instance_count" {
  type        = number
  default     = 0
  description = "Number of instances to launch."
}

variable "spot_configuration" {
  description = "Configuration options for the EC2 spot instance"
  type = object({
    spot_price                     = optional(string, null)
    wait_for_fulfillment           = optional(bool, false)
    spot_type                      = optional(string, null)
    launch_group                   = optional(string, null)
    instance_interruption_behavior = optional(string, null)
    valid_until                    = optional(string, null)
    valid_from                     = optional(string, null)
  })
  default = {}
}

variable "cpu_options" {
  description = "Defines CPU options to apply to the instance at launch time."
  type        = any
  default     = {}
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = any
  default     = {}
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type        = map(string)
  default     = {}
}

variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = map(string)
  default     = {}
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the aws_key_pair resource."
  type        = string
  default     = ""
}

variable "algorithm" {
  description = "Name of the algorithm to use when generating the private key. Currently-supported values are: RSA, ECDSA, ED25519."
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "When algorithm is RSA, the size of the generated RSA key, in bits (default: 2048)."
  type        = number
  default     = 4096
}

variable "egress_ipv4_from_port" {
  description = "Egress Start port (or ICMP type number if protocol is icmp or icmpv6)."
  type        = number
  default     = 0
}

variable "egress_ipv4_to_port" {
  description = "Egress end port (or ICMP code if protocol is icmp)."
  type        = number
  default     = 65535
}

variable "egress_ipv4_protocol" {
  description = "Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type        = string
  default     = "-1"
}

variable "egress_ipv4_cidr_block" {
  description = " List of CIDR blocks. Cannot be specified with source_security_group_id or self."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_ipv6_from_port" {
  description = "Egress Start port (or ICMP type number if protocol is icmp or icmpv6)."
  type        = number
  default     = 0
}

variable "egress_ipv6_to_port" {
  description = "Egress end port (or ICMP code if protocol is icmp)."
  type        = number
  default     = 65535
}

variable "egress_ipv6_protocol" {
  description = "Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type        = string
  default     = "-1"
}

variable "egress_ipv6_cidr_block" {
  description = " List of CIDR blocks. Cannot be specified with source_security_group_id or self."
  type        = list(string)
  default     = ["::/0"]
}

