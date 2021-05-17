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

variable "SG_SSH_WEB" {
  type    = list(string)
  default = ["sg-08ecbe0692fbe25ec", "sg-046381c78e6f224c2"]
}

variable "AMI_OWNERS" {
  type    = list(string)
  default = ["099720109477"]
}


variable "EC2_INST_USER_NAME" {
  default = "ubuntu"
}
