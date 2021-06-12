variable "nginx-ami" {
  type    = string
  default = "ami-0e5501c1baf0c52c7"
  #   default = "ami-01581ffba3821cdf3"
}

variable "zones" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "number" {
  type    = number
  default = 2
}

variable "private_ips_webserver" {
  type    = list(string)
  default = ["10.0.1.10", "10.0.3.10"]
}
