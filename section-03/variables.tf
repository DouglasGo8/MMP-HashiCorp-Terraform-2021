variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_PROFILE" {
  default = "default"
}

variable "PUB_SUBNET_1" {
  type    = string
  default = "subnet-0cb4ca829c6b717b3"
}

variable "SG_SSH" {
  type    = string
  default = "sg-001dd6fa41ef4df90"
}

variable "AMI_OWNERS" {
  type    = list(string)
  default = ["099720109477"]
}

#variable "AMIS" {
#  type = map(any)
#  default = {
#    us-east-1 = "ami_id"
#  }
#}
