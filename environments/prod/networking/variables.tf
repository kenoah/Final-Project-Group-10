variable "default_tags" {
  default = {
    "Owner" = "ACSGroup10"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

variable "env" {
  default     = "Prod"
  type        = string
  description = "Deployment environment"
}

variable "vpc_cidr" {
  default     = "10.250.0.0/16"
  type        = string
  description = "CIDR range of VPC for the PROD environment"
}

variable "public_subnet_cidrs" {
  default     = ["10.250.0.0/24", "10.250.1.0/24", "10.250.2.0/24"]
  type        = list(string)
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  default     = ["10.250.3.0/24", "10.250.4.0/24", "10.250.5.0/24"]
  type        = list(string)
  description = "Private subnet CIDRs"
}