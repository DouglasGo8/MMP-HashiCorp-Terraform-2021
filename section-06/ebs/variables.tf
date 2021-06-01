variable "AWS_REGION" {
  default = "sa-east-1"
}

variable "AWS_PROFILE" {
  default = "default"
}

variable "PUB_SUBNET_1" {
  type    = string
  default = "subnet-0301e4e51298985be"
}

variable "SG_SSH" {
  type    = string
  default = "sg-08ecbe0692fbe25ec"
}

variable "AMI_OWNERS" {
  type    = list(string)
  default = ["099720109477"]
}
