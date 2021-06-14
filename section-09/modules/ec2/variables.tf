variable "VPC_ID" {
  type    = string
  default = ""
}

variable "PUBLIC_SUBNETS" {
  type = list(any)
}
