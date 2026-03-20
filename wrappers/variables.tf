variable "items" {
  description = "Map of items to create multiple module instances"
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Default values for module instances"
  type        = any
  default     = {}
}
