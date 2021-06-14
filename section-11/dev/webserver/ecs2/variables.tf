variable "AWS_PROFILE" {
  default = "default"
}

variable "AWS_REGION" {
  type    = string
  default = "sa-east-1"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "dev"
}

variable "SSH_CIDR_WEB_SERVER" {
  type    = string
  default = "0.0.0.0/0"
}


variable "AMI_OWNERS" {
  type    = list(string)
  default = ["099720109477"]
}


variable "INSTANCE_TYPE" {
  default = "t2.micro"
}
