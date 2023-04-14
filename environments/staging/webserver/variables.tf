variable "default_tags" {
  default = {
    "Owner" = "ACSGroup10"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

variable "env" {
  default     = "staging"
  type        = string
  description = "Staging Environment"
}

variable "instance_type" {
  default     = "t3.small"
  type        = string
  description = "Type of the instance"
}

variable "asg_min_size" {
  default     = 1
  type        = number
  description = "Minimum number of instances in auto scaling group"
}

variable "asg_max_size" {
  default     = 4
  type        = number
  description = "Maximum number of instances in auto scaling group"
}

variable "asg_desired_capacity" {
  default     = 3
  type        = number
  description = "Desired number of instances in auto scaling group"
}