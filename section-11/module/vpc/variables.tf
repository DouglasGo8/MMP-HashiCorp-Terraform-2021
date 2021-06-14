
variable "AWS_REGION" {
  default = "sa-east-1"
}

variable "AWS_PROFILE" {
  default = "default"
}

variable "WEBAPP_CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "WEBAPP_VPC_PUBLIC_SUBNET01_CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.101.0/24"
}

variable "WEBAPP_VPC_PUBLIC_SUBNET02_CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.102.0/24"
}

variable "WEBAPP_VPC_PRIVATE_SUBNET01_CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "WEBAPP_VPC_PRIVATE_SUBNET02_CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "Development"
}
