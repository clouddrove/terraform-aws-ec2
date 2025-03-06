## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| algorithm | Name of the algorithm to use when generating the private key. Currently-supported values are: RSA, ECDSA, ED25519. | `string` | `"RSA"` | no |
| alias | The display name of the alias. The name must start with the word `alias` followed by a forward slash. | `string` | `"alias/ec2-test"` | no |
| allowed\_ip | List of allowed ip. | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| allowed\_ports | List of allowed ingress ports | `list(any)` | <pre>[<br>  80,<br>  443<br>]</pre> | no |
| assign\_eip\_address | Assign an Elastic IP address to the instance. | `bool` | `true` | no |
| capacity\_reservation\_specification | Describes an instance's Capacity Reservation targeting option | `any` | `{}` | no |
| cpu\_credits | The credit option for CPU usage. Can be `standard` or `unlimited`. T3 instances are launched as unlimited by default. T2 instances are launched as standard by default. | `string` | `"standard"` | no |
| cpu\_options | Defines CPU options to apply to the instance at launch time. | `any` | `{}` | no |
| customer\_master\_key\_spec | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| default\_instance\_enabled | Flag to control the instance creation. | `bool` | `true` | no |
| deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource. | `number` | `7` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | `string` | `"-"` | no |
| dns\_enabled | Flag to control the dns\_enable. | `bool` | `false` | no |
| dns\_zone\_id | The Zone ID of Route53. | `string` | `"Z1XJD7SSBKXLC1"` | no |
| ebs\_block\_device | Additional EBS block devices to attach to the instance | `list(any)` | `[]` | no |
| ebs\_device\_name | Name of the EBS device to mount. | `list(string)` | <pre>[<br>  "/dev/xvdb",<br>  "/dev/xvdc",<br>  "/dev/xvdd",<br>  "/dev/xvde",<br>  "/dev/xvdf",<br>  "/dev/xvdg",<br>  "/dev/xvdh",<br>  "/dev/xvdi",<br>  "/dev/xvdj",<br>  "/dev/xvdk",<br>  "/dev/xvdl",<br>  "/dev/xvdm",<br>  "/dev/xvdn",<br>  "/dev/xvdo",<br>  "/dev/xvdp",<br>  "/dev/xvdq",<br>  "/dev/xvdr",<br>  "/dev/xvds",<br>  "/dev/xvdt",<br>  "/dev/xvdu",<br>  "/dev/xvdv",<br>  "/dev/xvdw",<br>  "/dev/xvdx",<br>  "/dev/xvdy",<br>  "/dev/xvdz"<br>]</pre> | no |
| ebs\_iops | Amount of provisioned IOPS. This must be set with a volume\_type of io1. | `number` | `0` | no |
| ebs\_volume\_enabled | Flag to control the ebs creation. | `bool` | `false` | no |
| ebs\_volume\_size | Size of the EBS volume in gigabytes. | `number` | `30` | no |
| ebs\_volume\_type | The type of EBS volume. Can be standard, gp3 or io1. | `string` | `"gp3"` | no |
| egress\_ipv4\_cidr\_block | List of CIDR blocks. Cannot be specified with source\_security\_group\_id or self. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| egress\_ipv4\_from\_port | Egress Start port (or ICMP type number if protocol is icmp or icmpv6). | `number` | `0` | no |
| egress\_ipv4\_protocol | Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number | `string` | `"-1"` | no |
| egress\_ipv4\_to\_port | Egress end port (or ICMP code if protocol is icmp). | `number` | `65535` | no |
| egress\_ipv6\_cidr\_block | List of CIDR blocks. Cannot be specified with source\_security\_group\_id or self. | `list(string)` | <pre>[<br>  "::/0"<br>]</pre> | no |
| egress\_ipv6\_from\_port | Egress Start port (or ICMP type number if protocol is icmp or icmpv6). | `number` | `0` | no |
| egress\_ipv6\_protocol | Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number | `string` | `"-1"` | no |
| egress\_ipv6\_to\_port | Egress end port (or ICMP code if protocol is icmp). | `number` | `65535` | no |
| egress\_rule | Enable to create egress rule | `bool` | `true` | no |
| enable | Flag to control module creation. | `bool` | `true` | no |
| enable\_key\_pair | A boolean flag to enable/disable key pair. | `bool` | `true` | no |
| enable\_key\_rotation | Specifies whether key rotation is enabled. | `string` | `true` | no |
| enable\_security\_group | Enable default Security Group with only Egress traffic allowed. | `bool` | `true` | no |
| enclave\_options\_enabled | Whether Nitro Enclaves will be enabled on the instance. Defaults to `false` | `bool` | `null` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| hostname | DNS records to create. | `string` | `"ec2"` | no |
| iam\_instance\_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. | `string` | `null` | no |
| instance\_configuration | Configuration options for the EC2 instance | <pre>object({<br>    ami                                  = optional(string, "")<br>    ebs_optimized                        = optional(bool, false)<br>    instance_type                        = string<br>    monitoring                           = optional(bool, false)<br>    associate_public_ip_address          = optional(bool, true)<br>    disable_api_termination              = optional(bool, false)<br>    instance_initiated_shutdown_behavior = optional(string, "stop")<br>    placement_group                      = optional(string, "")<br>    tenancy                              = optional(string, "default")<br>    host_id                              = optional(string, null)<br>    cpu_core_count                       = optional(number, null)<br>    cpu_threads_per_core                 = optional(number, null)<br>    user_data                            = optional(string, "")<br>    user_data_base64                     = optional(string, null)<br>    user_data_replace_on_change          = optional(bool, null)<br>    availability_zone                    = optional(string, null)<br>    get_password_data                    = optional(bool, null)<br>    private_ip                           = optional(string, null)<br>    secondary_private_ips                = optional(list(string), null)<br>    source_dest_check                    = optional(bool, true)<br>    ipv6_address_count                   = optional(number, null)<br>    ipv6_addresses                       = optional(list(string), null)<br>    hibernation                          = optional(bool, false)<br>    root_block_device                    = optional(list(any), [])<br>    ephemeral_block_device               = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "instance_type": "t4g.small"<br>}</pre> | no |
| instance\_count | Number of instances to launch. | `number` | `0` | no |
| instance\_metadata\_tags\_enabled | Whether the metadata tag is available. Valid values include enabled or disabled. Defaults to enabled. | `string` | `"disabled"` | no |
| instance\_profile\_enabled | Flag to control the instance profile creation. | `bool` | `true` | no |
| instance\_tags | Instance tags. | `map(any)` | `{}` | no |
| is\_enabled | Specifies whether the key is enabled. | `bool` | `true` | no |
| is\_external | enable to udated existing security Group | `bool` | `false` | no |
| key\_name | Key name of the Key Pair to use for the instance; which can be managed using the aws\_key\_pair resource. | `string` | `""` | no |
| key\_usage | Specifies the intended use of the key. Defaults to ENCRYPT\_DECRYPT, and only symmetric encryption and decryption are supported. | `string` | `"ENCRYPT_DECRYPT"` | no |
| kms\_description | The description of the key as viewed in AWS console. | `string` | `"Parameter Store KMS master key"` | no |
| kms\_key\_enabled | Specifies whether the kms is enabled or disabled. | `bool` | `true` | no |
| kms\_key\_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true. | `string` | `""` | no |
| kms\_multi\_region | Indicates whether the KMS key is a multi-Region (true) or regional (false) key. | `bool` | `false` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| launch\_template | Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template | `map(string)` | `{}` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| metadata\_http\_endpoint\_enabled | Whether the metadata service is available. Valid values include enabled or disabled. Defaults to enabled. | `string` | `"enabled"` | no |
| metadata\_http\_put\_response\_hop\_limit | The desired HTTP PUT response hop limit (between 1 and 64) for instance metadata requests. | `number` | `2` | no |
| metadata\_http\_tokens\_required | Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Valid values include optional or required. Defaults to optional. | `string` | `"optional"` | no |
| multi\_attach\_enabled | Specifies whether to enable Amazon EBS Multi-Attach. Multi-Attach is supported on io1 and io2 volumes. | `bool` | `false` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| network\_interface | Customize network interfaces to be attached at instance boot time | `list(map(string))` | `[]` | no |
| protocol | The protocol. If not icmp, tcp, udp, or all use the. | `string` | `"tcp"` | no |
| public\_key | Name  (e.g. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-ec2"` | no |
| rsa\_bits | When algorithm is RSA, the size of the generated RSA key, in bits (default: 2048). | `number` | `4096` | no |
| sg\_description | The security group description. | `string` | `"Instance default security group (only egress access is allowed)."` | no |
| sg\_egress\_description | Description of the egress and ingress rule | `string` | `"Description of the rule."` | no |
| sg\_egress\_ipv6\_description | Description of the egress\_ipv6 rule | `string` | `"Description of the rule."` | no |
| sg\_ids | of the security group id. | `list(any)` | `[]` | no |
| sg\_ingress\_description | Description of the ingress rule | `string` | `"Description of the ingress rule use elasticache."` | no |
| spot\_configuration | Configuration options for the EC2 spot instance | <pre>object({<br>    spot_price                     = optional(string, null)<br>    wait_for_fulfillment           = optional(bool, false)<br>    spot_type                      = optional(string, null)<br>    launch_group                   = optional(string, null)<br>    block_duration_minutes         = optional(number, null)<br>    instance_interruption_behavior = optional(string, null)<br>    valid_until                    = optional(string, null)<br>    valid_from                     = optional(string, null)<br>  })</pre> | `{}` | no |
| spot\_instance\_count | Number of instances to launch. | `number` | `0` | no |
| spot\_instance\_enabled | Flag to control the instance creation. | `bool` | `true` | no |
| spot\_instance\_tags | Instance tags. | `map(any)` | `{}` | no |
| ssh\_allowed\_ip | List of allowed ip. | `list(any)` | `[]` | no |
| ssh\_allowed\_ports | List of allowed ingress ports | `list(any)` | `[]` | no |
| ssh\_protocol | The protocol. If not icmp, tcp, udp, or all use the. | `string` | `"tcp"` | no |
| ssh\_sg\_ingress\_description | Description of the ingress rule | `string` | `"Description of the ingress rule use elasticache."` | no |
| subnet\_ids | A list of VPC Subnet IDs to launch in. | `list(string)` | `[]` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| timeouts | Define maximum timeout for creating, updating, and deleting EC2 instance resources | `map(string)` | `{}` | no |
| ttl | The TTL of the record to add to the DNS zone to complete certificate validation. | `string` | `"300"` | no |
| type | Type of DNS records to create. | `string` | `"CNAME"` | no |
| vpc\_id | The ID of the VPC that the instance security group belongs to. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the instance. |
| az | The availability zone of the instance. |
| instance\_count | The count of instances. |
| instance\_id | The instance ID. |
| ipv6\_addresses | A list of assigned IPv6 addresses. |
| key\_name | The key name of the instance. |
| name | Name of SSH key. |
| placement\_group | The placement group of the instance. |
| private\_ip | Private IP of instance. |
| public\_ip | Public IP of instance (or EIP). |
| spot\_bid\_status | The current bid status of the Spot Instance Request |
| spot\_instance\_id | The instance ID. |
| subnet\_id | The EC2 subnet ID. |
| tags | The instance ID. |
| vpc\_security\_group\_ids | The associated security groups in non-default VPC. |

