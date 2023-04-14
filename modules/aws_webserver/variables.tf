variable "acs_group" {
  default     = "Group10"
  type        = string
  description = "Name of the group to be used as prefix"
}

variable "tg_protocol" {
  default     = "HTTP"
  type        = string
  description = "Target group protocol"
}

variable "tg_port" {
  default     = 80
  type        = number
  description = "Target group port"
}

variable "listener_protocol" {
  default     = "HTTP"
  type        = string
  description = "Listener protocol"
}

variable "listener_port" {
  default     = 80
  type        = number
  description = "Listener port"
}

variable "default_tags" {
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

variable "env" {
  type        = string
  description = "Specifies the deployment environment"
}

variable "instance_type" {
  type        = string
  description = "Type of the instance"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in auto scaling group"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in auto scaling group"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in auto scaling group"
}